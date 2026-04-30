import {
  DynamoDBClient,
  QueryCommand,
  PutItemCommand,
  DeleteItemCommand,
  UpdateItemCommand,
} from "@aws-sdk/client-dynamodb";
import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi";
import { notifyClient } from "./notify-client.js";
import { setConnectionStatus } from "./set-connection-status.js";
import { startsWith, z } from "zod";
import { languages } from "./language.js";
import { countries } from "./countries.js";
import { MatchmakingRequestSchema } from "./schemas.js";

const dynamoClient = new DynamoDBClient({});
const { CONNECTIONS_TABLE, MATCHMAKING_TABLE } = process.env;

export const handler = async (event) => {
  const body = JSON.parse(event.body);
  let parsedBody = null;

  try {
    parsedBody = MatchmakingRequestSchema.parse(body);
  } catch (err) {
    console.error("Validation Error:", err);
    return {
      statusCode: 400,
      body: JSON.stringify({
        error: "Validation failed",
        details: err,
      }),
    };
  }

  console.log(
    "Validation passed. UserData:",
    JSON.stringify(parsedBody.userData),
  );

  const domainName = event.requestContext.domainName;
  const stage = event.requestContext.stage;
  const callbackUrl = `https://${domainName}/${stage}`;
  const apiGwClient = new ApiGatewayManagementApiClient({
    endpoint: callbackUrl,
  });

  const connectionId = event.requestContext.connectionId;
  const userData = parsedBody.userData;
  const filters = parsedBody.filters || {};

  /**
   * 1. Mirror strategy to build filters
   */
  const requiredNativeLanguage =
    filters.requiredNativeLanguage || userData.targetLanguage;
  const requiredTargetLanguage =
    filters.requiredTargetLanguage || userData.nativeLanguage;
  const requiredLocation = filters.requiredLocation || null;

  const searchPK =
    userData.targetLanguage === "any"
      ? userData.targetLanguage
      : `${requiredTargetLanguage}`;

  try {
    /**
     * 2. Search candidates to make match
     */
    console.log("Searching candidates for:", searchPK);
    const queryParams = {
      TableName: MATCHMAKING_TABLE,
      KeyConditionExpression: "targetLanguageShard = :pk",
      ExpressionAttributeValues: {
        ":pk": { S: searchPK },
      },
      Limit: 50,
    };

    const { Items } = await dynamoClient.send(new QueryCommand(queryParams));
    console.log("Candidates found:", Items ? Items.length : 0);

    let bestMatch = null;
    let highestScore = -1;

    /**
     * 3. Scoring: in memory ranking of candidates based on filters = n points.
     */
    if (Items && Items.length > 0) {
      for (const candidate of Items) {
        if (candidate.userId.S === userData.userId) continue;

        let score = 0;

        if (userData.targetLanguage !== "any") {
          if (candidate.targetLanguage.S !== requiredTargetLanguage) continue;
          if (candidate.nativeLanguage.S === requiredNativeLanguage)
            score += 50;
        }

        if (requiredLocation && candidate.location?.S === requiredLocation) {
          score += 20;
        }

        if (score > highestScore) {
          highestScore = score;
          bestMatch = candidate;
        }
      }
    }

    /**
     * 4. Match attempt: Steal the best candidate with a conditional delete.
     * If it fails, it means someone else got them just milliseconds before us,
     * and we just join the queue.
     */
    if (bestMatch && (highestScore > 0 || userData.targetLanguage === "any")) {
      console.log("Attempting match with candidate:", bestMatch.userId.S);
      try {
        await dynamoClient.send(
          new DeleteItemCommand({
            TableName: MATCHMAKING_TABLE,
            Key: {
              targetLanguageShard: { S: bestMatch.targetLanguageShard.S },
              createdAt: { N: bestMatch.createdAt.N },
            },
            ConditionExpression: "attribute_exists(targetLanguageShard)",
          }),
        );

        await setConnectionStatus(
          dynamoClient,
          connectionId,
          "BUSY",
          CONNECTIONS_TABLE,
        );
        await setConnectionStatus(
          dynamoClient,
          bestMatch.connectionId.S,
          "BUSY",
          CONNECTIONS_TABLE,
        );

        /**
         * 5. Notify callee
         */
        await notifyClient(apiGwClient, bestMatch.connectionId.S, {
          action: "match_found",
          role: "callee",
          peerConnectionId: connectionId,
          peerData: userData,
        });

        /**
         * 6. Notify caller: who offers webRTC connection
         */
        await notifyClient(apiGwClient, connectionId, {
          action: "match_found",
          role: "caller",
          peerConnectionId: bestMatch.connectionId.S,
          peerData: {
            userId: bestMatch.userId.S,
            nativeLanguage: bestMatch.nativeLanguage.S,
            targetLanguage: bestMatch.targetLanguage.S,
            location: bestMatch.location?.S,
          },
        });

        return {
          statusCode: 200,
          body: "Matched",
        };
      } catch (err) {
        if (err.name === "ConditionalCheckFailedException") {
          // For MVP we just join the queue
          console.log(
            "Race condition: candidate already matched by someone else, joining queue",
          );
        } else {
          throw err;
        }
      }
    }

    /**
     * 7. No match found, join the queue
     */
    console.log("No match found, joining queue.");
    const timestamp = Date.now().toString();
    const ttl = Math.floor(Date.now() / 1000) + 5 * 60; // 5 minutes TTL
    const myQueuePK =
      userData.targetLanguage === "any" ? "any" : `${userData.targetLanguage}`;

    await dynamoClient.send(
      new PutItemCommand({
        TableName: MATCHMAKING_TABLE,
        Item: {
          targetLanguageShard: { S: myQueuePK },
          createdAt: { N: timestamp },
          userId: { S: userData.userId },
          connectionId: { S: connectionId },
          nativeLanguage: { S: userData.nativeLanguage },
          targetLanguage: { S: userData.targetLanguage },
          location: { S: userData.location || "unknown" },
          ttl: { N: ttl.toString() },
        },
      }),
    );

    /**
     * 8. Update connection status to "MATCHING" and store queue position
     */
    console.log("Updating connection status.");
    await dynamoClient.send(
      new UpdateItemCommand({
        TableName: CONNECTIONS_TABLE,
        Key: { connectionId: { S: connectionId } },
        UpdateExpression: "SET #status = :s, match_pk = :mpk, match_sk = :msk",
        ExpressionAttributeNames: { "#status": "status" },
        ExpressionAttributeValues: {
          ":s": { S: "MATCHING" },
          ":mpk": { S: myQueuePK },
          ":msk": { N: timestamp },
        },
      }),
    );

    // Enviar el mensaje explícitamente a través de Management API
    await notifyClient(apiGwClient, connectionId, {
      action: "waiting_in_queue",
    });

    return {
      statusCode: 200,
      body: "Enqueued",
    };
  } catch (error) {
    console.error("Critical error in findMatch:", error);
    return { statusCode: 500, body: "Error finding match" };
  }
};

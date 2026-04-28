import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const CONNECTIONS_TABLE = process.env.CONNECTIONS_TABLE;

export const handler = async (event) => {
  const connectionId = event.requestContext.connectionId;

  const userId = event.queryStringParameters?.userId;

  if (!userId) {
    console.error("Error: userId missing in query parameters");
    return { statusCode: 403, body: "Forbidden: userId missing" };
  }

  if (!userId.startsWith("usr_") && !userId.startsWith("gst_")) {
    console.error("Error: Invalid prefix for userId");
    return {
      statusCode: 403,
      body: "Forbidden: Invalid prefix (expected 'usr_' or 'gst_')",
    };
  }

  const ttlSeconds = Math.floor(Date.now() / 1000) + 1 * 60 * 60; // 1 hour
  const currentTimestamp = Date.now().toString();

  const params = {
    TableName: CONNECTIONS_TABLE,
    Item: {
      connectionId: { S: connectionId },
      userId: { S: userId },
      status: { S: "ONLINE" },
      lastHeartbeat: { N: currentTimestamp },
      ttl: { N: ttlSeconds.toString() },
    },
  };

  try {
    await client.send(new PutItemCommand(params));

    console.log(
      `Connection successful: ${connectionId} linked to user: ${userId}`,
    );

    return { statusCode: 200, body: "Connected" };
  } catch (error) {
    console.error(`Error saving connection to DynamoDB:`, error);
    return { statusCode: 500, body: "Internal Server Error" };
  }
};

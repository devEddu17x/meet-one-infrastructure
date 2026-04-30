import {
  DynamoDBClient,
  GetItemCommand,
  DeleteItemCommand,
} from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const { CONNECTIONS_TABLE, MATCHMAKING_TABLE } = process.env;

export const handler = async (event) => {
  const connectionId = event.requestContext.connectionId;

  try {
    const getParams = {
      TableName: CONNECTIONS_TABLE,
      Key: { connectionId: { S: connectionId } },
    };
    const { Item } = await client.send(new GetItemCommand(getParams));

    if (Item) {
      const status = Item.status.S;

      if (status === "MATCHING" && Item.match_pk && Item.match_sk) {
        await client.send(
          new DeleteItemCommand({
            TableName: MATCHMAKING_TABLE,
            Key: {
              targetLanguageShard: { S: Item.match_pk.S },
              createdAt: { N: Item.match_sk.N },
            },
          }),
        );
      }
    }

    await client.send(
      new DeleteItemCommand({
        TableName: CONNECTIONS_TABLE,
        Key: { connectionId: { S: connectionId } },
      }),
    );

    return { statusCode: 200, body: "Disconnected" };
  } catch (error) {
    console.error("Error en $disconnect:", error);
    return { statusCode: 500, body: "Error during disconnect" };
  }
};

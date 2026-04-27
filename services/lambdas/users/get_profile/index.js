import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient();

export const handler = async (event) => {
  try {
    const userId = event.requestContext.authorizer.claims.sub;

    const { Item } = await client.send(
      new GetItemCommand({
        TableName: process.env.USERS_TABLE,
        Key: { userId: { S: userId } },
      }),
    );

    if (!Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: "Profile not found" }),
      };
    }

    const profile = {
      userId: Item.userId.S,
      name: Item.name?.S,
      email: Item.email?.S,
      nativeLanguage: Item.nativeLanguage?.S,
      targetLanguage: Item.targetLanguage?.S,
      gender: Item.gender?.S,
      location: Item.location?.S,
      createdAt: Item.createdAt?.N ? Number(Item.createdAt.N) : undefined,
    };

    return {
      statusCode: 200,
      body: JSON.stringify(profile),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Internal server error",
        details: err.message,
      }),
    };
  }
};

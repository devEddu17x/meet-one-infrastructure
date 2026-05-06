import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { z } from "zod";
import { countries } from "./countries.js";
import { languages } from "./language.js";

const client = new DynamoDBClient();

const UserSchema = z.object({
  name: z.string().min(1).max(100),
  nativeLanguage: z.string().refine((v) => languages.includes(v), {
    message: "Invalid native language",
  }),
  targetLanguage: z.string().refine((v) => languages.includes(v), {
    message: "Invalid target language",
  }),
  gender: z.string().refine((v) => ["male", "female", "other"].includes(v), {
    message: "Invalid gender",
  }),
  location: z.string().refine((v) => countries.includes(v), {
    message: "Invalid location",
  }),
});

export const handler = async (event) => {
  try {
    const userId = event.requestContext.authorizer.claims.sub;
    const body = JSON.parse(event.body);
    const parsed = UserSchema.parse(body);
    const email = event.requestContext.authorizer.claims.email;

    if (!userId) {
      return {
        statusCode: 400,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Content-Type,Authorization"
        },
        body: JSON.stringify({ error: "User ID is required" }),
      };
    }
    const item = {
      userId: { S: userId },
      name: { S: parsed.name },
      email: { S: email },
      nativeLanguage: { S: parsed.nativeLanguage },
      targetLanguage: { S: parsed.targetLanguage },
      gender: { S: parsed.gender },
      location: { S: parsed.location },
      createdAt: { N: Date.now().toString() },
    };

    await client.send(
      new PutItemCommand({
        TableName: process.env.USERS_TABLE,
        Item: item,
        ConditionExpression: "attribute_not_exists(userId)",
      }),
    );

    return {
      statusCode: 201,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type,Authorization"
      },
      body: JSON.stringify({
        message: "Profile created",
        user: { ...parsed, userId },
      }),
    };
  } catch (err) {
    if (err instanceof z.ZodError) {
      return {
        statusCode: 400,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Content-Type,Authorization"
        },
        body: JSON.stringify({
          error: "Validation failed",
          details: err.errors,
        }),
      };
    }
    if (err.name === "ConditionalCheckFailedException") {
      return {
        statusCode: 409,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Content-Type,Authorization"
        },
        body: JSON.stringify({ error: "Profile already exists" }),
      };
    }
    return {
      statusCode: 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type,Authorization"
      },
      body: JSON.stringify({
        error: "Internal server error",
        details: err.message,
      }),
    };
  }
};

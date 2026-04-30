import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";
export async function setConnectionStatus(dynamoClient, connId, status, table) {
  try {
    await dynamoClient.send(
      new UpdateItemCommand({
        TableName: table,
        Key: { connectionId: { S: connId } },
        UpdateExpression: "SET #status = :s",
        ExpressionAttributeNames: { "#status": "status" },
        ExpressionAttributeValues: { ":s": { S: status } },
      }),
    );
  } catch (e) {
    console.error(`Error while updating connection status for ${connId}:`, e);
  }
}

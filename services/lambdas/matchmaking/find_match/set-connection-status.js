export async function setConnectionStatus(connId, status) {
  try {
    await dynamoClient.send(
      new UpdateItemCommand({
        TableName: CONNECTIONS_TABLE,
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

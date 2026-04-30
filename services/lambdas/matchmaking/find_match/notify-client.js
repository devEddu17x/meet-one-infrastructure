export async function notifyClient(connId, payload) {
  try {
    await apiGwClient.send(
      new PostToConnectionCommand({
        ConnectionId: connId,
        Data: new TextEncoder().encode(JSON.stringify(payload)),
      }),
    );
  } catch (e) {
    console.log(`Unable to notify ${connId}, possible disconnection:`, e);
  }
}

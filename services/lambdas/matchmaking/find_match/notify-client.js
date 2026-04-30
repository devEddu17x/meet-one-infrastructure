import { PostToConnectionCommand } from "@aws-sdk/client-apigatewaymanagementapi";

export async function notifyClient(apiClient, connId, payload) {
  try {
    await apiClient.send(
      new PostToConnectionCommand({
        ConnectionId: connId,
        Data: new TextEncoder().encode(JSON.stringify(payload)),
      }),
    );
  } catch (e) {
    console.log(`Unable to notify ${connId}, possible disconnection:`, e);
  }
}

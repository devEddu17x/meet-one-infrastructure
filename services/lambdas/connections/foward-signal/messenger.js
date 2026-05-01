import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi";

export async function forwardMessage(endpoint, targetConnectionId, payload) {
  const client = new ApiGatewayManagementApiClient({ endpoint });

  try {
    await client.send(
      new PostToConnectionCommand({
        ConnectionId: targetConnectionId,
        Data: new TextEncoder().encode(JSON.stringify(payload)),
      }),
    );
    console.log(`Successfully forwarded signal to ${targetConnectionId}`);
  } catch (error) {
    if (
      error.$metadata?.httpStatusCode === 410 ||
      error.name === "GoneException"
    ) {
      console.log(`Connection ${targetConnectionId} is gone. Disconnected.`);
    } else {
      console.error(
        `Failed to forward signal to ${targetConnectionId}:`,
        error,
      );
      throw error;
    }
  }
}

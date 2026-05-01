import { forwardMessage } from "./messenger.js";
import { ForwardSignalBodySchema } from "./schema.js";
export const handler = async (event) => {
  console.log("Received forwardSignal event:", event.body);

  try {
    const { requestContext, body } = event;
    const { connectionId, domainName, stage } = requestContext;
    const endpoint = `https://${domainName}/${stage}`;

    if (!domainName || !stage) {
      throw new Error("Missing domainName or stage in requestContext");
    }

    const parsedBody = JSON.parse(body);
    const result = ForwardSignalBodySchema.safeParse(parsedBody);

    if (!result.success) {
      forwardMessage(endpoint, connectionId, {
        error: "Invalid request body",
        details: result.error.errors,
      });
    }

    const { targetConnectionId, signalData } = result.data;
    if (!targetConnectionId || !signalData) {
      console.error("Missing targetConnectionId or signalData");
      return {
        statusCode: 400,
        body: "Bad Request: Missing targetConnectionId or signalData",
      };
    }

    const payloadToForward = {
      senderConnectionId: connectionId,
      signalData: signalData,
    };

    await forwardMessage(endpoint, targetConnectionId, payloadToForward);

    return {
      statusCode: 200,
      body: "Signal forwarded successfully",
    };
  } catch (error) {
    console.error("Error in forwardSignal handler:", error);
    return {
      statusCode: 500,
      body: "Internal Server Error",
    };
  }
};

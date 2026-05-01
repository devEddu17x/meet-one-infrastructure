export const getTurnServerCredentials = async () => {
  const tokenId = process.env.CLOUDFLARE_TURN_TOKEN_ID;
  const apiToken = process.env.CLOUDFLARE_TURN_API_TOKEN;

  if (!tokenId || !apiToken) {
    console.warn(
      "Cloudflare TURN credentials are not configured in environment variables.",
    );
    return null;
  }

  try {
    const response = await fetch(
      `https://rtc.live.cloudflare.com/v1/turn/keys/${tokenId}/credentials/generate-ice-servers`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${apiToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ ttl: 300 }),
      },
    );

    if (!response.ok) {
      console.log(
        `Cloudflare API error: ${response.status} ${response.statusText}`,
      );
      return null;
    }

    const data = await response.json();
    return data.iceServers;
  } catch (error) {
    console.error("Failed to fetch TURN credentials from Cloudflare:", error);
    return null;
  }
};

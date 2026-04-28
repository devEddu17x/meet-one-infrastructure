const {
  CognitoIdentityProviderClient,
  AdminAddUserToGroupCommand,
} = require("@aws-sdk/client-cognito-identity-provider");

const client = new CognitoIdentityProviderClient();

exports.handler = async (event) => {
  const userPoolId = event.userPoolId;
  const username = event.userName;
  const groupName = "public-user";

  try {
    await client.send(
      new AdminAddUserToGroupCommand({
        UserPoolId: userPoolId,
        Username: username,
        GroupName: groupName,
      }),
    );
    return event;
  } catch (err) {
    console.error("Error adding user to group:", err);
    throw err;
  }
};

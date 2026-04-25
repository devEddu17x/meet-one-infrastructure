### Deployment Strategy

Infrastructure is managed as code to ensure reproducible environments. The backend utilizes AWS SAM (Serverless Application Model) for resource provisioning.

### Cloud Resource Mapping

- **DynamoDB (Connections Table):** Tracks active WebSocket connections and user mapping.
- **DynamoDB (Matchmaking Table):** Uses `TargetLanguage` as the Partition Key to enable high-speed queries for available peers.
- **Systems Manager Parameter Store:** Securely stores Cloudflare API credentials and Cognito resource IDs.

### Unit Economics Analysis

The architecture is designed to minimize AWS Data Transfer Out (DTO), which is the primary cost driver in video applications.

- **Base Scenario (100 - 5,000 users):** Operational costs remain at approximately 0 USD due to AWS Free Tier thresholds for Lambda, API Gateway, and DynamoDB.
- **Scalability Scenario (100,000 users):** \* **Signaling:** Costs scale linearly based on the volume of WebSocket messages.
  - **Media:** Video costs remain negligible for the provider as long as P2P is successful. Only 15-20% of traffic (NAT traversal failures) incurs Cloudflare Calls usage fees.

## docs/security.md

### Security Protocols

- **Signaling Validation:** All WebSocket requests require a valid Cognito JWT.
- **Media Privacy:** While the MVP prioritizes P2P for cost efficiency, Cloudflare Calls acts as a proxy for relayed connections, masking end-user IP addresses.
- **Input Sanitization:** Lambda functions validate language codes and message schemas to prevent injection attacks within the DynamoDB matching logic.
- **Secrets Management:** No credentials are hardcoded; all sensitive strings are retrieved at runtime from AWS Parameter Store.

---

**MeetOne Guide:** Your blueprint is now technically documented and ready for a multi-repo setup. Since the frontend is separate, your Vue.js developers only need to know the WebSocket message schema and the Cognito Client ID to start building.

Would you like to define the specific JSON schemas for the `find-match` and `forward-signal` messages to complete the developer hand-off?

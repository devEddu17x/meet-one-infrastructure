## MeetOne: Real-time Language Exchange Platform

MeetOne is a real-time language exchange application designed to connect users instantly for audio and video practice. This repository contains the backend infrastructure, signaling logic, and matching engine. The platform is built on a serverless, P2P-first architecture to ensure high scalability and near-zero operational costs.

## Architecture Overview

The system follows a technology-agnostic approach regarding media transport, utilizing AWS serverless components for control logic and decentralized protocols for data transmission.

### Core Capabilities

- **Signaling:** Managed via WebSockets to orchestrate WebRTC session negotiations (SDP/ICE) without intermediate media servers in the control flow.
- **Matching Engine:** Distributed logic within ephemeral compute functions that process user queues based on native and target language criteria.
- **Media Transport:** Native WebRTC implementation with an automated fallback mechanism to relay servers.
- **Persistence:** State management for presence and session metadata using eventual consistency and automated TTL-based cleanup.

### Technical Stack

| Layer                  | Technology                | Role                                                      |
| :--------------------- | :------------------------ | :-------------------------------------------------------- |
| **Frontend**           | Vue.js (Vite)             | _External Repository_ - Manages UI and RTCPeerConnection. |
| **Hosting (Frontend)** | Vercel                    | Static asset delivery and CI/CD for the client.           |
| **Auth**               | Amazon Cognito            | Identity provider and JWT issuer.                         |
| **API / Signaling**    | AWS API Gateway (WS/REST) | Message orchestration and entry points.                   |
| **Compute**            | AWS Lambda                | Business logic and matchmaking processing.                |
| **Persistence**        | Amazon DynamoDB           | NoSQL storage with TTL for queue management.              |
| **Media Relay**        | Cloudflare Calls          | TURN/SFU provider for NAT traversal fallback.             |
| **STUN**               | Google Public STUN        | Public IP discovery for P2P connections.                  |

## Operational Flow

1.  **Authentication:** The client authenticates via Cognito to obtain an identity token.
2.  **Presence:** A persistent connection is established through API Gateway WebSocket; the `connectionId` is mapped to the user in DynamoDB.
3.  **Matching:** The user submits preferences; a Lambda function queries the matchmaking table for compatible peers and notifies both parties via WebSocket.
4.  **Handshake:** Clients exchange SDP offers and answers through the signaling channel (`forward-signal` Lambda).
5.  **Media Establishment:** The browsers attempt a direct P2P connection. If a timeout occurs (3 seconds), the client utilizes the Cloudflare Calls token provided during the matching phase to relay the call.

## Repository Structure

- `/functions`: Source code for AWS Lambda functions (Node.js).
- `/iac`: Infrastructure as Code templates (SAM/Terraform).
- `/docs`: Technical specifications and economic analysis.

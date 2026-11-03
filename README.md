# TrustChain — Decentralized Giving Platform

<p align="center">
  <strong>Transparent Giving · Powered by Ethereum</strong>
</p>

TrustChain is a blockchain-based charity donation and fund-tracking platform designed to improve transparency, accountability, and trust in charitable fundraising.

The platform brings donors, NGOs, and administrators together through a web application integrated with Ethereum-compatible smart contracts. It provides campaign management, donation tracking, milestone-based fund management, and verifiable transaction records.

**Repository:** https://github.com/khushi-shukla-cz/Trustchain

---

## Overview

Traditional charity systems can make it difficult for donors to independently track how funds are collected, allocated, and released. TrustChain explores how blockchain technology and smart contracts can improve the visibility and traceability of charitable transactions.

The application provides dedicated interfaces for donors, NGOs, and administrators, along with blockchain-powered workflows for supported operations.

## Key Features

### Campaign Management
- Create and manage fundraising campaigns.
- Browse available charity campaigns.
- View campaign details and funding goals.
- Monitor campaign funding progress.

### Donor Features
- Connect a wallet.
- Explore charitable initiatives.
- Interact with supported donation workflows.
- View donation and transaction information.

### NGO Features
- NGO dashboard and campaign management.
- Milestone request interface.
- Evidence upload and SHA-256 file hashing.
- Campaign and funding information.

### Blockchain Features
- Solidity-based smart contracts.
- Local Ethereum-compatible blockchain using Ganache.
- MetaMask wallet integration.
- Transaction verification.
- Smart contract deployment using Hardhat.

### Transparency and Administration
- Transaction and receipt interfaces.
- Fund allocation and milestone tracking.
- Admin control interface.
- Blockchain explorer interface.
- Security and activity information.

*The implementation status of individual modules depends on the corresponding frontend, API, and smart contract functionality. Refer to the current code and demo guide when evaluating a particular feature.*

---

## Technology Stack

| Component | Technology |
|---|---|
| Frontend | Next.js, React, TypeScript |
| Backend | Node.js / API services |
| Database | PostgreSQL |
| Blockchain | Ethereum-compatible local network |
| Smart Contracts | Solidity |
| Development Framework | Hardhat |
| Local Blockchain | Ganache |
| Wallet | MetaMask |
| Containerization | Docker |
| File Integrity | SHA-256 |
| Version Control | Git and GitHub |

---

## Project Structure

```text
Trustchain/
│
├── frontend/                 # User interface
│
├── backend/                  # Backend API services
│
├── blockchain/               # Smart contracts and deployment
│
├── docker-compose.yml        # Container configuration
├── package.json              # Root scripts
├── package-lock.json
├── setup.js                  # Project setup
├── start.js                  # Application launcher
│
├── QUICK_START_MAC.md        # macOS setup guide
├── demo-guide.md             # Demonstration instructions
├── cookbook.pdf
│
└── README.md
```

---

## System Architecture

```text
             DONORS / NGOs / ADMIN
                       |
                       v
               TRUSTCHAIN FRONTEND
                  Next.js + React
                       |
                       v
                  BACKEND API
                       |
              +--------+--------+
              |                 |
              v                 v
          PostgreSQL       Blockchain Layer
                                |
                                v
                         Solidity Contracts
                                |
                                v
                             Ganache
                                |
                                v
                        Transaction Records
```

MetaMask is used for wallet connectivity and transaction authorization where supported.

---

## Getting Started

### Prerequisites

Install the following:

- Node.js 20 or 22
- npm
- Docker Desktop
- MetaMask browser extension
- Git

Make sure Docker Desktop is running before starting the application.

### 1. Clone the Repository

```bash
git clone https://github.com/khushi-shukla-cz/Trustchain.git
cd Trustchain
```

### 2. Initial Setup

Run the project setup command:

```bash
npm run setup
```

This prepares the project dependencies and local configuration.

### 3. Start TrustChain

```bash
npm start
```

The project launcher is designed to:

1. Start or use the local Ganache blockchain.
2. Compile and deploy the Solidity contracts.
3. Start PostgreSQL through Docker if required.
4. Launch the backend API.
5. Launch the frontend application.

Keep the terminal running while using the application.

### 4. Open the Application

Frontend:

http://localhost:3000

Backend health endpoint:

http://localhost:4000/api/health

---

## MetaMask Configuration

Connect MetaMask to the local TrustChain blockchain.

| Setting | Value |
|---|---|
| Network Name | TrustChain Local |
| RPC URL | http://127.0.0.1:8545 |
| Chain ID | 1337 |
| Currency Symbol | ETH |

For local testing, the launcher uses a development-only Ganache mnemonic:

```text
test test test test test test test test test test test junk
```

Only use these development accounts with the local test network. Never use this mnemonic or its accounts to store real assets.

### Wallet Connection

1. Open the TrustChain application.
2. Select Connect Wallet.
3. Choose MetaMask.
4. Approve the connection.
5. Confirm that the wallet is connected to TrustChain Local.

---

## Smart Contract Deployment

The blockchain directory contains the Solidity contracts and deployment configuration.

The root launcher handles compilation and deployment during startup.

To run the contract tests:

```bash
npm run test:contracts
```

For direct development, navigate to the blockchain directory and use its configured Hardhat scripts.

After redeployment, verify that the frontend and backend are using the latest contract address and ABI.

---

## Running Components Individually

The root package provides commands for installing and running the individual components.

Install dependencies across the project:

```bash
npm run install:all
```

Start the local blockchain:

```bash
npm run chain
```

Deploy contracts:

```bash
npm run deploy
```

Start backend and frontend development servers together:

```bash
npm run dev
```

For the recommended integrated launch, use:

```bash
npm start
```

---

## Demonstration Workflow

A typical demonstration can follow these steps:

1. Launch TrustChain and connect MetaMask.
2. Open the Explore Campaigns section.
3. View campaign information and funding progress.
4. Open the NGO Dashboard.
5. Create or inspect a campaign.
6. Explore the Escrow and Milestones interface.
7. Submit a milestone request where the contract conditions allow it.
8. Upload a supporting document and generate its SHA-256 hash.
9. Inspect transaction information.
10. Demonstrate the transparency and audit interfaces.

### Sample Demonstration Data

| Field | Example |
|---|---|
| Campaign | Education Support |
| Funding Goal | 2 ETH |
| Duration | 12 days |
| Milestone | Purchase of Educational Supplies |
| Requested Amount | 0.01 ETH |

Use test accounts and test ETH only. A sample evidence document should be labelled as demonstration material, not as proof of a real purchase or delivery.

---

## Security Considerations

- Wallet transactions require user authorization.
- Smart contracts enforce the rules implemented in their code.
- Transaction records can be inspected on the local blockchain.
- SHA-256 can be used to detect whether a file has changed.
- Sensitive information should not be exposed in uploaded evidence.
- Private keys, recovery phrases, and environment secrets must never be committed to GitHub.

A document hash establishes file integrity; it does not independently prove that the document is genuine.

---

## Current Limitations

- The local Ganache environment is intended for development and demonstration.
- Restarting Ganache resets its local blockchain state; contracts must be redeployed.
- A local blockchain does not process real charitable donations.
- Live wallet and escrow workflows must be tested against the deployed contract.
- File hashing does not verify the truthfulness of uploaded evidence.
- The current setup guide notes that live MetaMask browser testing and IPFS implementation are not included in the verified release.

---

## Future Scope

- Deploy smart contracts to an Ethereum testnet or production network.
- Integrate IPFS for decentralized evidence storage.
- Implement multi-signature fund release.
- Extend milestone approval workflows.
- Introduce DAO-based governance.
- Add beneficiary verification.
- Generate automated donation receipts.
- Improve analytics and fund utilization reporting.
- Add comprehensive automated testing and security audits.

---

## Academic Project Information

| Detail | Information |
|---|---|
| Project | TrustChain — Decentralized Giving Platform |
| Domain | Blockchain and Smart Contracts |
| Institution | Vivekanand Education Society's Institute of Technology (VESIT) |
| Developer | Khushi Shukla |
| Academic Year | 2026–2027 |

---

## License

This project is developed for academic and educational purposes. Add a formal open-source license before permitting reuse or redistribution.

---

<p align="center">
  <strong>TRUSTCHAIN</strong><br/>
  Building trust through transparency, one transaction at a time.
</p>

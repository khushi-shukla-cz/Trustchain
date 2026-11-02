# TrustChain — Quick Start (macOS)

## Prerequisites (one time)
- Node.js 20 or 22, npm
- Docker Desktop installed **and running** (PostgreSQL)
- MetaMask browser extension
- Internet for initial npm package installation

## First run
From the extracted `TrustChain` directory:

```bash
npm run setup
npm start
```

`npm start` starts Ganache (if needed), compiles and deploys Solidity contracts, starts PostgreSQL using Docker if needed, then starts the API and frontend. Keep this terminal open.

Open **http://localhost:3000** once Next.js prints `Ready`.

## Subsequent runs
```bash
npm start
```

## MetaMask local network
- Network name: TrustChain Local
- RPC URL: `http://127.0.0.1:8545`
- Chain ID: `1337`
- Symbol: `ETH`

For this local demo, Ganache uses the **publicly known development-only mnemonic** `test test test test test test test test test test test junk`. Only import these test accounts. **Never send real funds or use this mnemonic on a public network.**

## Verify
- Frontend: http://localhost:3000
- API health: http://localhost:4000/api/health
- Tests: `npm run test:contracts`

## Troubleshooting
- If port 8545 is already used, the launcher assumes an existing Ganache network. Stop conflicting services if contract deployment fails.
- If port 3000 is in use, Next.js may choose 3001; use the address printed in the terminal.
- If Docker isn't running, start Docker Desktop and retry.
- If dependencies were installed using an incompatible Node version, delete `node_modules` folders and rerun `npm run setup`.
- If the launcher reports compilation or Next.js errors, those must be fixed before claiming the project is working.

## Current limitations
This is a simplified launcher and dependency/configuration update, **not a verified end-to-end release**. No live MetaMask browser test or IPFS implementation is included. The backend requires Docker/PostgreSQL, and internet is required for the first install. The blockchain is reset if Ganache is stopped and restarted; deployment addresses are rewritten on each start.

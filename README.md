# DeProp - Decentralized Property Investment Platform 🏢

A smart contract for fractional real estate investment built on the Stacks blockchain.

## Overview 🔍

DeProp enables users to:
- Purchase shares in properties
- Collect rental income based on share ownership
- Manage property investments through smart contracts

## Features ✨

- **Property Registration**: Admins can register new properties with customizable shares
- **Share Trading**: Users can buy property shares
- **Rent Distribution**: Automated rent collection and distribution
- **Ownership Tracking**: Transparent tracking of share ownership
- **Built-in NFT Support**: Utilizes NFT traits for ownership representation

## Contract Structure 📁

```
DeProp/
├── contracts/
│   ├── DeProp.clar       # Main contract
│   └── nft-trait.clar    # NFT trait definition
```

## Key Functions 🔧

### Administrative
- `register-property`: Register new properties
- `distribute-rent`: Distribute rental income

### User Functions
- `buy-shares`: Purchase shares in properties
- `claim-rent`: Claim accumulated rental income
- `get-property`: View property details
- `get-shares`: Check share ownership

## Data Maps 📊

- `properties`: Stores property details
- `ownership`: Tracks user share ownership

## Getting Started 🚀

### Prerequisites
- Stacks wallet
- STX tokens for transactions

### Deployment
1. Deploy `nft-trait.clar`
2. Deploy `DeProp.clar`
3. Initialize properties through admin account

## Testing 🧪

```bash
clarinet test
```

## Security 🔒

- Admin-only functions for sensitive operations
- Safe transfer mechanisms
- Built-in ownership verification




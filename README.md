# Introduction
This project is an introduction to smart contract, integrating it with javascript via a tic tac toe game.

Each player pays 0.01 ether to play the game. The winner takes the money. If there is a draw, money is refunded to both players.

# Structure
* [3-truffle-project/](3-truffle-project): Build, test and deploy smart contract to local blockchain
* [4-game-in-html/](4-game-in-html): Integrate smart contract with the web.
  * [contracts/](4-game-in-html/contracts): Smart contracts
  * [app/](4-game-in-html/app): The frontend code

# Design
![Design](images/web3-tic-tac-toe-game.png)

# Local development
* Install ganache: `npm install -g ganache-cli`
* Install truffle: `npm install-g truffle`
* Start ganache, which runs a local blockchain at localhost:8545: `ganache-cli`
* Run truffle migration to deploy the smart contracts: `truffle migrate`
* Start frontend: `npm run dev`
* Build frontend: `npm run build`

## Connect to metamask
**Localhost**
![Metamask localhost](4-game-in-html/images/metamask-localhost-8545-network-setting.png)

# Demo - localhost
**2 incognito windows**
![localhost 2 incognito window](https://i.imgur.com/tex1lVu.gif)

**non-incognito(metamask) and incognito window**
![localhost non-incognito and incognito window](https://i.imgur.com/vnTZZsL.gif)

# Demo - sepolia testnet
[Try it here](https://hanchiang.github.io/complete-crypto-currency-and-blockchain-course-learn-solidity/)

**Using google chrome and firefox**
![Sepolia testnet](https://i.imgur.com/srHi7kN.gif)


## Sepolia testnet
**Contract**
https://sepolia.etherscan.io/address/0x70bafdcb86bf63b9d2d0c0519d8cefd9ba166a8b

**Faucet**
https://www.infura.io/faucet/sepolia  
https://sepoliafaucet.com/  
https://faucets.chain.link/

# Deploy to testnet
* cd `4-game-in-html`
* Create `.env` file with the following variables:
  * `MNEMONIC`: From ganache
  * `PROJECT_ID`: Create a project in [infura](https://www.infura.io/)
* `truffle migrate --network sepolia`


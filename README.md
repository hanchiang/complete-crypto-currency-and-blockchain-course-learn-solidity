
# Local development
* Install ganache: `npm install -g ganache-cli`
* Install truffle: `npm install-g truffle`
* Start ganache, which runs a local blockchain at localhost:8545: `ganache-cli`
* Run truffle migration to deploy the smart contracts: `truffle migrate`

## Connect to metamask
**Localhost**
![Metamask localhost](4-game-in-html/images/metamask-localhost-8545-network-setting.png)

# Demo - localhost
**2 incognito windows**
![localhost 2 incognito window](https://i.imgur.com/tex1lVu.gif)
**non-incognito(metamask) and incognito window**
![localhost non-incognito and incognito window](https://i.imgur.com/vnTZZsL.gif)

<blockquote class="imgur-embed-pub" lang="en" data-id="a/2PgbqeO" data-context="false" ><a href="//imgur.com/a/2PgbqeO"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

# Deploy to testnet
truffle migrate --network goerli
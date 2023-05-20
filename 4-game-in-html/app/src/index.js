import Web3 from "web3";
import $ from "jquery";
import contract from "truffle-contract"

import gameManagerArtifact from "../../build/contracts/GameManager.json"
import threeInARowArtifact from "../../build/contracts/ThreeInARow.json"

const App = {
  web3: null,
  account: null,
  gameManager: null,
  threeInARow: null,

  start: async function() {
    const { web3 } = this;

    try {
      this.gameManager = contract(gameManagerArtifact);
      this.gameManager.setProvider(web3.currentProvider);

      this.threeInARow = contract(threeInARowArtifact);
      this.threeInARow.setProvider(web3.currentProvider);

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

      this.gameManager.defaults({
        from: this.account
      });
      this.threeInARow.defaults({
        from: this.account
      });
    } catch (error) {
      console.error("Could not connect to contract or chain.", error);
    }
  },
  refreshHighscore: async function() {
    const { gameManager } = this;
    const gameManagerInstance = await gameManager.deployed();
    const top10 = await gameManagerInstance.getTop10();
    console.log(top10);
  },
  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.WebsocketProvider("ws://127.0.0.1:8545"),
    );
  }

  App.start();
});

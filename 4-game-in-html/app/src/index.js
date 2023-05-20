import Web3 from "web3";
import $ from "jquery";
import contract from "truffle-contract"

import gameManagerArtifact from "../../build/contracts/GameManager.json"
import threeInARowArtifact from "../../build/contracts/ThreeInARow.json"

const App = {
  web3: null,
  account: null,
  accountTwo: null,
  activeAccount: null,
  gameManager: null,
  threeInARow: null,
  activeThreeInARowInstance: null,

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
      this.activeAccount = this.account;
      this.accountTwo = accounts[1];

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
  setAccountTwo: function() {
    this.threeInARow.defaults({
      from: this.accountTwo
    });
    this.activeAccount = this.accountTwo;
  },
  refreshHighscore: async function() {
    const { gameManager } = this;
    const gameManagerInstance = await gameManager.deployed();
    const top10 = await gameManagerInstance.getTop10();
    console.log(top10);
  },
  createNewGame: async function() {
    const { gameManager, web3, threeInARow }  = this;

    const gameManagerInstance = await gameManager.deployed();
    const txResult = await gameManagerInstance.startNewGame({ value: web3.utils.toWei('0.1', 'ether') });
    console.log(txResult);
    this.activeThreeInARowInstance = await threeInARow.at(txResult.logs[0].args._game);

    this.activeThreeInARowInstance.PlayerJoined().on('data', (event) => {
      console.log(`player joined event:`, event);
      event.args._player;
    })

    this.listenToEvents();
  },
  joinGame: async function(gameAddress) {
    const { web3, threeInARow } = this;

    this.activeThreeInARowInstance = await threeInARow.at(gameAddress);

    this.listenToEvents();

    await this.activeThreeInARowInstance.joinGame({ from: this.accountTwo, value: web3.utils.toWei('0.1', 'ether') });
  },
  setStone: async function(row, col) {
    await this.activeThreeInARowInstance.setStone(row, col);
  },
  updateBoard: async function() {
    const board = await this.activeThreeInARowInstance.getBoard();
    console.log(board);

    for (let r = 0; r < board.length; r++) {
      for (let c = 0; c < board[r].length; c++) {
        if (board[r][c] == this.activeAccount) {
          $("#board")[0].children[0].children[r].children[c].innerHTML = "X";
        } else if (board[r][c] != 0) {
          $("#board")[0].children[0].children[r].children[c].innerHTML = "O";
        }
      }
    }
  },
  listenToEvents: async function() {
    const { activeThreeInARowInstance, web3 }  = this;
    const self = this;

    activeThreeInARowInstance.NextPlayer().on('data', (event) => {
      console.log(`next player event:`, event);
      if (event.args._player == self.activeAccount) {
        console.log("Your turn!");
      } else {
        console.log("Waiting for opponent");
      }
      self.updateBoard();
    })
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

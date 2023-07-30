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
  isLocalhost: true,

  start: async function() {
    const { web3 } = this;

    try {
      this.gameManager = contract(gameManagerArtifact);
      this.gameManager.setProvider(web3.currentProvider);

      this.threeInARow = contract(threeInARowArtifact);
      this.threeInARow.setProvider(web3.currentProvider);

      // get accounts
      const accounts = await web3.eth.getAccounts();
      console.log(accounts)
      this.account = accounts[0];
      this.activeAccount = this.account;
      this.accountTwo = this.isLocalhost ? accounts[1] : accounts[0];

      this.gameManager.defaults({
        from: this.account
      });
      this.threeInARow.defaults({
        from: this.account
      });

      this.refreshHighscore();
      this.gameStopped();
      this.displayPlayerAddress();
      
    } catch (error) {
      console.error("Could not connect to contract or chain.", error);
    }
  },
  setAccountTwo: function() {
    this.threeInARow.defaults({
      from: this.accountTwo
    });
    this.activeAccount = this.accountTwo;
    this.displayPlayerAddress();
  },
  refreshHighscore: async function() {
    const { gameManager } = this;
    const gameManagerInstance = await gameManager.deployed();
    const top10 = await gameManagerInstance.getTop10();
    console.log(top10);

    const highscoreRows = $('#highscore tr');
    const highscoreTable = $('#highscore');

    for (let i = 1; i < highscoreRows.length; i++) {
      highscoreRows[i].remove();
    }

    top10[0].forEach((address, index) => {
      highscoreTable.append("<tr><td>" + (index + 1) + "</td><td>" + address + "</td><td>" + top10[1][index] + "</td></tr>");
    });

    return top10;
  },
  createNewGame: async function() {
    const { gameManager, web3, threeInARow }  = this;

    const gameManagerInstance = await gameManager.deployed();
    const txResult = await gameManagerInstance.startNewGame({ value: web3.utils.toWei('0.01', 'ether') });
    console.log(txResult);
    this.activeThreeInARowInstance = await threeInARow.at(txResult.logs[0].args._game);

    this.activeThreeInARowInstance.PlayerJoined().on('data', (event) => {
      console.log(`player joined event:`, event);
    })

    await this.resetBoard();
    this.gameJoining();

    this.listenToEvents();

    return txResult;
  },
  joinGame: async function(gameAddress) {
    const { web3, threeInARow } = this;

    this.activeThreeInARowInstance = await threeInARow.at(gameAddress);

    await this.resetBoard();

    this.displayPlayerAddress();

    this.listenToEvents();

    await this.activeThreeInARowInstance.joinGame({ from: this.accountTwo, value: web3.utils.toWei('0.01', 'ether') });
  },
  listenToEvents: async function() {
    const { activeThreeInARowInstance, web3 }  = this;
    const self = this;

    activeThreeInARowInstance.NextPlayer().on('data', (event) => {
      console.log(`next player event:`, event);
      if (event.args._player == self.activeAccount) {
        self.setStatus("Your turn!");
      } else {
        self.setStatus("Waiting for opponent");
      }
      self.updateBoard(event.args._player == self.activeAccount);
      this.gameRunning();
    });

    activeThreeInARowInstance.GameOverWithWin().on('data', (event) => {
      if (event.args._winner == self.activeAccount) {
        self.setStatus("Congratuations, you are the winner!");
      } else {
        self.setStatus("Oh my! You lost!");
      }
      self.refreshHighscore();
      self.updateBoard(false);
      this.gameOver();
    });

    activeThreeInARowInstance.GameOverWithDraw().on('data', (event) => {
      self.setStatus("Nobody won!");
      self.updateBoard(false);
      this.gameOver();
    })
  },
  displayPlayerAddress: function() {
    $('#playerAddress')[0].innerHTML = this.activeAccount;
  },
  gameStopped: function() {
    $('.game-stopped').show();
    $('.game-over').hide();
    $('.game-running').hide();
  },
  gameRunning: function() {
    $('.game-stopped').hide();
    $('.game-over').hide();
    $('.game-running').show();
  },
  gameJoining: function() {
    $('.game-stopped').hide();
    $('.game-over').show();
    $('.game-running').hide();
  },
  gameOver: function() {
    $('.game-stopped').hide();
    $('.game-over').show();
    $('.game-running').show();
  },
  setStone: async function(event) {
    console.log(event);
    const { row, col } = event.data;
    await this.activeThreeInARowInstance.setStone(row, col);

    const board = await this.activeThreeInARowInstance.getBoard();

    $($("#board")[0].children[0].children[row].children[col]).off('click')
  },
  resetBoard: async function() {
    const board = await this.activeThreeInARowInstance.getBoard();

    for (let r = 0; r < board.length; r++) {
      for (let c = 0; c < board[r].length; c++) {
        $("#board")[0].children[0].children[r].children[c].innerHTML = "";
      }
    }
  },
  updateBoard: async function(clickable) {
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

    for (let r = 0; r < board.length; r++) {
      for (let c = 0; c < board[r].length; c++) {
        if ($("#board")[0].children[0].children[r].children[c].innerHTML == "") {
          const cell = $($("#board")[0].children[0].children[r].children[c]).off('click');
          if (clickable) {
            cell.click({
              row: r,
              col: c,
              instance: this.activeThreeInARowInstance
            }, App.setStone.bind(this));
          }
        }
      }
    }
  },
  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
};

window.App = App;

window.addEventListener("load", async function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    await window.ethereum.enable(); // get permission to access accounts

    const chainIdHex = App.web3.currentProvider.chainId;
    const sepoliaIdHex = '0xaa36a7';
    if (chainIdHex !== sepoliaIdHex) {
      console.log('wrong network');
      try {
        await App.web3.currentProvider.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId: sepoliaIdHex }]
        });
      } catch (error) {
        console.log(error);
        alert(error.message);
      }
    }

    window.ethereum.on("chainChanged", () => {
      window.location.reload();
    });

    window.ethereum.on('accountsChanged', () => {
      window.location.reload();
    });

    this.isLocalhost = false;
    document.getElementById("selectAccount2").style.display = 'none';  // Do not show select account 2 if user is using a provider
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

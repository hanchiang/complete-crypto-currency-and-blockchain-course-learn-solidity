pragma solidity >= 0.5.0 < 0.9.0;

import { GameManager } from "./GameManager.sol";

contract ThreeInARow {
    GameManager gameManager;

    uint256 public gameCost = 0.1 ether;

    address payable public player1;
    address payable public player2;
    address payable public activePlayer;

    event PlayerJoined(address _player);
    event NextPlayer(address _player);
    event GameOverWithWin(address _winner);
    event GameOverWithDraw();
    event PayoutSuccess(address receiver, uint _amountInWei);

    address[3][3] gameBoard;
    bool gameActive;

    uint8 movesCounter;

    uint balanceToWithdrawPlayer1;
    uint balanceToWithdrawPlayer2;

    uint gameValidUntil;
    uint timeToReact = 3 minutes;

    constructor(address _gameManager, address payable _player1) public payable {
        gameManager = GameManager(_gameManager);
        require(msg.value == gameCost, "Submit more money! Aborting!");
        player1 = _player1;
    }

    // player 2 joins the game
    function joinGame() public payable {
        assert(player2 == address(0x0));
        assert(!gameActive);
        require(player2 != player1, "Player 2 must be different from player1!");
        require(msg.value == gameCost, "Submit more money! Aborting!");
        
        player2 = payable(msg.sender);
        emit PlayerJoined(player2);

        if (block.number % 2 == 0) {
            activePlayer = player2;
        } else {
            activePlayer = player1;
        }

        gameActive = true;
        gameValidUntil = block.timestamp + timeToReact;
        emit NextPlayer(activePlayer);
    }

    function getBoard() public view returns(address[3][3] memory) {
        return gameBoard;
    }

    function setStone(uint8 row, uint col) public {
        uint8 boardSize = uint8(gameBoard.length);
        assert(gameActive);
        require(gameValidUntil >= block.timestamp);
        require(row >= 0 && row < boardSize, "Invalid row coordinate");
        require(col >= 0 && col < boardSize, "Invalid y coordinate");
        require(gameBoard[row][col] == address(0x0), "Cannot set a stone that is already set!");
        require(msg.sender == activePlayer, "It is not your turn!");
        
        gameBoard[row][col] = msg.sender;
        movesCounter++;

        // check win - vertical
        for (uint8 i = 0 ; i < boardSize; i++) {
            if (gameBoard[i][col] != activePlayer) {
                break;
            }
            if (i == boardSize - 1) {
                setWinner(activePlayer);
                return;
            }
        }
        // check win - horizontal
        for (uint8 i = 0 ; i < boardSize; i++) {
            if (gameBoard[row][i] != activePlayer) {
                break;
            }
            if (i == boardSize - 1) {
                setWinner(activePlayer);
                return;
            }
        }
        // check win - diagonal
        if (row == col) {
            for (uint8 i = 0; i < boardSize; i++) {
                if (gameBoard[i][i] != activePlayer) {
                    break;
                }
                if (i == boardSize - 1) {
                    setWinner(activePlayer);
                    return;
                }
            }
        }
        // check win - anti diagonal
        if ((row + col) == boardSize - 1) {
            for (uint8 i = 0; i < boardSize; i++) {
                if (gameBoard[i][boardSize - 1 - i] != activePlayer) {
                    break;
                }
                if (i == boardSize -1) {
                    setWinner(activePlayer);
                    return;
                }
            }
        }

        // check draw
        if (movesCounter == boardSize ** 2) {
            setDraw();
            return;
        }

        activePlayer = activePlayer == player1 ? player2 : player1;

        emit NextPlayer(activePlayer);
    }

    function setWinner(address payable _player) private {
        require(gameActive);
        gameActive = false;
        gameManager.enterWinner(_player);
        uint balanceToPayout = address(this).balance;
        if (!_player.send(balanceToPayout)) {
            if (_player == player1) {
                balanceToWithdrawPlayer1 += balanceToPayout;
            } else if (_player == player2) {
                balanceToWithdrawPlayer2 += balanceToPayout;
            }
        } else {
            emit PayoutSuccess(_player, balanceToPayout);
        }
        emit GameOverWithWin(_player);
    }

    function setDraw() private {
        require(gameActive);
        gameActive = false;
        uint balanceToPayout = address(this).balance / 2;
        if (!player1.send(balanceToPayout)) {
            balanceToWithdrawPlayer1 += balanceToPayout;
        } else {
            emit PayoutSuccess(player1, balanceToPayout);
        }
        if (!player2.send(balanceToPayout)) {
            balanceToWithdrawPlayer2 += balanceToPayout;
        } else {
            emit PayoutSuccess(player2, balanceToPayout);
        }

        emit GameOverWithDraw();
    }

    function withdraw(address payable _to) public {
        if (msg.sender == player1) {
            require(balanceToWithdrawPlayer1 > 0);
            uint balanceToWithdraw = balanceToWithdrawPlayer1;
            balanceToWithdrawPlayer1 = 0;
            _to.transfer(balanceToWithdraw);
            emit PayoutSuccess(player1, balanceToWithdraw);
        } else if (msg.sender == player2) {
            require(balanceToWithdrawPlayer2 > 0);
            uint balanceToWithdraw = balanceToWithdrawPlayer2;
            balanceToWithdrawPlayer2 = 0;
            _to.transfer(balanceToWithdraw);
            emit PayoutSuccess(player2, balanceToWithdraw);
        }
    }

    function emergencyCashout() public {
        require(gameValidUntil < block.timestamp);
        require(gameActive);
        setDraw();
    }
}
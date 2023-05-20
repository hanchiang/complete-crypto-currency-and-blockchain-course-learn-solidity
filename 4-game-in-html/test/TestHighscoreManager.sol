pragma solidity >= 0.5.0 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "truffle/console.sol";
import "../contracts/HighscoreManager.sol";

contract TestHighscoreManager {
    // TODO: remove onlyGameManager from addWinner() for testing
    // Find a better way to do this
    function testBasicTop10Works() public {
        HighscoreManager highscoreManager = new HighscoreManager(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));

        address[10] memory winners = [
            address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9), address(10)
        ];
        for (uint i = 0; i < winners.length; i++) {
            highscoreManager.addWinner(winners[i]);
        }

        address[10] memory top10Addresses;
        uint[10] memory top10Wins;
        (top10Addresses, top10Wins) = highscoreManager.getTop10();
        for (uint i = 0; i < winners.length; i++) {
            Assert.equal(top10Addresses[i], winners[i], "Should have 1 winner");
            Assert.equal(top10Wins[i], 1, "Winner should have score 1");
        }
    }

    function testWinnerAtFirstPosition() public {
        HighscoreManager highscoreManager = new HighscoreManager(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));

        address[10] memory winners = [
            address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9), address(10)
        ];
        for (uint i = 0; i < winners.length; i++) {
            highscoreManager.addWinner(winners[i]);
        }
        highscoreManager.addWinner(winners[0]);

        address[10] memory expectedWinners = [
            address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9), address(10)
        ];
        uint256[10] memory expectedWins = [
            uint256(2), uint256(1), uint256(1), uint256(1), uint256(1),
            uint256(1), uint256(1), uint256(1), uint256(1), uint256(1)
        ];

        address[10] memory top10Addresses;
        uint[10] memory top10Wins;
        (top10Addresses, top10Wins) = highscoreManager.getTop10();
        for (uint i = 0; i < winners.length; i++) {
            Assert.equal(top10Addresses[i], expectedWinners[i], "Expect winner");
            Assert.equal(top10Wins[i], expectedWins[i], "Expect win");
        }
    }

    function testWinnerAtLastPosition() public {
        HighscoreManager highscoreManager = new HighscoreManager(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));

        address[10] memory winners = [
            address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9), address(10)
        ];
        for (uint i = 0; i < winners.length; i++) {
            highscoreManager.addWinner(winners[i]);
        }
        highscoreManager.addWinner(winners[winners.length - 1]);

        address[10] memory expectedWinners = [
            address(10), address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9)
        ];
        uint256[10] memory expectedWins = [
            uint256(2), uint256(1), uint256(1), uint256(1), uint256(1),
            uint256(1), uint256(1), uint256(1), uint256(1), uint256(1)
        ];

        address[10] memory top10Addresses;
        uint[10] memory top10Wins;
        (top10Addresses, top10Wins) = highscoreManager.getTop10();
        for (uint i = 0; i < winners.length; i++) {
            Assert.equal(top10Addresses[i], expectedWinners[i], "Expect winner");
            Assert.equal(top10Wins[i], expectedWins[i], "Expect win");
        }
    }

    function testWinnerBetweenFirstAndLastPosition() public {
        HighscoreManager highscoreManager = new HighscoreManager(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));

        address[10] memory winners = [
            address(1), address(2), address(3), address(4), address(5),
            address(6), address(7), address(8), address(9), address(10)
        ];
        for (uint i = 0; i < winners.length; i++) {
            highscoreManager.addWinner(winners[i]);
        }
        highscoreManager.addWinner(winners[4]);

        address[10] memory expectedWinners = [
            address(5), address(1), address(2), address(3), address(4),
            address(6), address(7), address(8), address(9), address(10)
        ];
        uint256[10] memory expectedWins = [
            uint256(2), uint256(1), uint256(1), uint256(1), uint256(1),
            uint256(1), uint256(1), uint256(1), uint256(1), uint256(1)
        ];

        address[10] memory top10Addresses;
        uint[10] memory top10Wins;
        (top10Addresses, top10Wins) = highscoreManager.getTop10();
        for (uint i = 0; i < winners.length; i++) {
            Assert.equal(top10Addresses[i], expectedWinners[i], "Expect winner");
            Assert.equal(top10Wins[i], expectedWins[i], "Expect win");
        }
    }
}
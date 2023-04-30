pragma solidity >= 0.5.0 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GameManager.sol";

contract TestGameManager {
    function testInitialHighScoreIsZero() public {
        GameManager gameManager = GameManager(DeployedAddresses.GameManager());

        (address[10] memory top10Addresses, uint[10] memory top10Wins) = gameManager.getTop10();
        Assert.equal(top10Addresses[0], address(0), "Should have no winner initially");
        Assert.equal(top10Wins[0], 0, "Should have 0 wins initially");
    }
}
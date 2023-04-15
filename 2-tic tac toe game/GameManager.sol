pragma solidity >= 0.5.0 < 0.9.0;

import {ThreeInARow} from "./ThreeInARow.sol";
import {HighscoreManager} from "./HighscoreManager.sol";

contract GameManager {
    HighscoreManager highscoreManager;

    event EventGameCreated(address _player, address _game);

    constructor() public {
        highscoreManager = new HighscoreManager(address(this));
    }

    function enterWinner(address _winner) public {

    }

    function getTop10() public view {
        
    }

    function startNewGame() public payable {
        ThreeInARow threeInARow = (new ThreeInARow){value: msg.value}(address(this), msg.sender);
        emit EventGameCreated(msg.sender, address(threeInARow));
    }
}
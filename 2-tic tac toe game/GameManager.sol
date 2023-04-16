pragma solidity >= 0.5.0 < 0.9.0;

import {ThreeInARow} from "./ThreeInARow.sol";
import {HighscoreManager} from "./HighscoreManager.sol";

contract GameManager {
    HighscoreManager public highscoreManager;

    event EventGameCreated(address _player, address _game);

    mapping(address => bool) allowedToEnterHighscore;

    modifier onlyInGameHighscoreEditing() {
        require(allowedToEnterHighscore[msg.sender], "You are not allowed to enter a highscore");
        _;
    }

    constructor() public {
        highscoreManager = new HighscoreManager(address(this));
    }

    function enterWinner(address _winner) public onlyInGameHighscoreEditing {
        highscoreManager.addWinner(_winner);
    }

    function getTop10() public view returns(address[10] memory, uint[10] memory) {
        return highscoreManager.getTop10();
    }

    function startNewGame() public payable {
        ThreeInARow threeInARow = (new ThreeInARow){value: msg.value}(address(this), msg.sender);
        allowedToEnterHighscore[address(threeInARow)] = true;
        emit EventGameCreated(msg.sender, address(threeInARow));
    }
}
pragma solidity >= 0.5.0 < 0.9.0;

contract HighscoreManager {
    address gameManager;
    
    constructor(address _gameManager) public {
        gameManager = _gameManager;
    }
    
    modifier onlyGameManager() {
        require(msg.sender == gameManager);
        _;
    }

    function addWinner(address _winner) public onlyGameManager {

    }

    function getTop10 () public view {
        
    }
}
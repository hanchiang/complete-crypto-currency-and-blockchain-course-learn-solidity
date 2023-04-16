pragma solidity >= 0.5.0 < 0.9.0;

contract HighscoreManager {
    address gameManager;
    uint8 NUM_HIGH_SCORES;

    event NewWinAdded(address _winner, uint _totalWins);

    struct Highscore {
        uint numberOfWins;
        uint timeOfLastWin;
        address prev;
        address next;
    }

    mapping(address => Highscore) public highscoreMapping;
    address public highscoreHolder;
    
    constructor(address _gameManager) public {
        gameManager = _gameManager;
        NUM_HIGH_SCORES = 10;
    }
    
    modifier onlyGameManager() {
        require(msg.sender == gameManager);
        _;
    }

    function addWinner(address _winner) public onlyGameManager {
        highscoreMapping[_winner].numberOfWins++;
        highscoreMapping[_winner].timeOfLastWin = block.timestamp;

        emit NewWinAdded(_winner, highscoreMapping[_winner].numberOfWins);

        if (highscoreHolder == address(0x0)) {
            highscoreHolder = _winner;
            return;
        }
        
        // update top 10 list
        if (highscoreHolder == _winner) {
            return;
        }
        address currentPosition = highscoreHolder;
        uint count = 0;

        for (uint i = 0; i < NUM_HIGH_SCORES; i++) {
            if (highscoreMapping[currentPosition].numberOfWins < highscoreMapping[_winner].numberOfWins) {
                // _winner is not in the list - add to the last element
                // before: 1-2, after: 1-3
                if (count == NUM_HIGH_SCORES - 1) {
                    highscoreMapping[_winner].prev = highscoreMapping[currentPosition].prev;
                    highscoreMapping[highscoreMapping[currentPosition].prev].next = _winner;
                    highscoreMapping[currentPosition].prev = address(0x0);
                } else {
                    // winner is in the list
                    // before: 1-2, after: 2-1
                    // before: 1-2-3, after: 1-3-2
                    // before: 1-2-3-4, after: 1-3-2-4

                    // connect current's prev to winner
                    if (highscoreMapping[currentPosition].prev != address (0x0)) {
                        highscoreMapping[highscoreMapping[currentPosition].prev].next = _winner;
                        highscoreMapping[_winner].prev = highscoreMapping[currentPosition].prev;
                    }

                    // connect winner's next to current
                    if (highscoreMapping[_winner].next != address(0x0)) {
                        highscoreMapping[highscoreMapping[_winner].next].prev = currentPosition;
                        highscoreMapping[currentPosition].next = highscoreMapping[_winner].next;
                    }

                    // update current and winner direction
                    highscoreMapping[_winner].prev = highscoreMapping[currentPosition].prev;
                    highscoreMapping[currentPosition].prev = _winner;
                    highscoreMapping[currentPosition].next = highscoreMapping[_winner].next;
                    highscoreMapping[_winner].next = currentPosition;
                }

                if (highscoreMapping[_winner].numberOfWins > highscoreMapping[highscoreHolder].numberOfWins) {
                    highscoreHolder = _winner;
                }
                return;
            }
            currentPosition = highscoreMapping[currentPosition].next;
        }   
    }

    function getTop10() public view returns(address[10] memory, uint[10] memory){
        address[10] memory topTenAddresses;
        uint[10] memory topTenWins;

        uint8 count = 0;
        address currPosition = highscoreHolder;

        for (uint i = 0 ; i < NUM_HIGH_SCORES; i++) {
            if (currPosition == address(0x0)) {
                break;
            }
            Highscore memory highScore = highscoreMapping[currPosition];
            topTenAddresses[i] = currPosition;
            topTenWins[i] = highScore.numberOfWins;
            currPosition = highscoreMapping[currPosition].next;
        }

        return (topTenAddresses, topTenWins);
    }
}
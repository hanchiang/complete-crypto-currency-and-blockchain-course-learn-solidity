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
    uint8 numAddressesInHighscore;
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

        // update highscore holder
        if (highscoreHolder == address(0x0)) {
            highscoreHolder = _winner;
            numAddressesInHighscore++;
        }

        if (highscoreHolder == _winner) {
            return;
        }

        // update winner list
        address currentPosition = highscoreHolder;
        for (uint i = 0; i < NUM_HIGH_SCORES; i++) {
            // winner is not yet added to the highscore list
            // TODO: Maintain a tail pointer for convenience
            bool winnerAlreadyInList = highscoreMapping[_winner].numberOfWins > 1;

            if (numAddressesInHighscore < NUM_HIGH_SCORES && !winnerAlreadyInList &&
                highscoreMapping[currentPosition].next == address(0) &&
                highscoreMapping[_winner].prev == address(0) && highscoreMapping[_winner].next == address(0)
            ) {
                highscoreMapping[currentPosition].next = _winner;
                highscoreMapping[_winner].prev = currentPosition;
                numAddressesInHighscore++;
                return;
            }
            if (highscoreMapping[currentPosition].numberOfWins < highscoreMapping[_winner].numberOfWins) {
                // winner is the 2nd position
                // before: 1(10)-2(10)-3(9), after: 2(11)-1(10)-3(9)

                // winner is the last position
                // before: 1(11)-2(10)-3(10), after: 1(11)-3(11)-2(10)

                // winner is the last position, and move up a few positions
                // before 1(10)-2(6)-3(6)-4(6), after: 1(10)-4(7)-2(6)-3(6)

                // update winner's prev
                if (highscoreMapping[_winner].prev != address(0x0)) {
                    highscoreMapping[highscoreMapping[_winner].prev].next = highscoreMapping[_winner].next;
                }
                // update winner's next
                if (highscoreMapping[_winner].next != address(0x0)) {
                    highscoreMapping[highscoreMapping[_winner].next].prev = highscoreMapping[_winner].prev;
                }
                // update current's prev
                if (highscoreMapping[currentPosition].prev != address(0x0)) {
                    highscoreMapping[highscoreMapping[currentPosition].prev].next = _winner;
                }
                // update current's next
                if (highscoreMapping[currentPosition].next != address(0x0)) {
                    highscoreMapping[highscoreMapping[currentPosition].next].prev = highscoreMapping[currentPosition].prev;
                }
                
                // update winner
                highscoreMapping[_winner].prev = highscoreMapping[currentPosition].prev;
                highscoreMapping[_winner].next = currentPosition;

                // update current
                highscoreMapping[currentPosition].prev = _winner;

                // last place is out of the list
                if (i == NUM_HIGH_SCORES - 1) {
                    highscoreMapping[currentPosition].prev = address(0);
                    highscoreMapping[currentPosition].next = address(0);
                }

                if (highscoreMapping[_winner].numberOfWins > highscoreMapping[highscoreHolder].numberOfWins) {
                    highscoreHolder = _winner;
                }
                return;
            }
            currentPosition = highscoreMapping[currentPosition].next;
            if (currentPosition == address(0)) {
                return;
            }
        }
    }

    function getTop10() public view returns(address[10] memory, uint[10] memory){
        address[10] memory topTenAddresses;
        uint[10] memory topTenWins;

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
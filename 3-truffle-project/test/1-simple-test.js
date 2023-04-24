const GameManager = artifacts.require('GameManager');
const ThreeInARow = artifacts.require('ThreeInARow');

// Start ganache: ganache-cli
// Run test: truffle test
contract('ThreeInARow test', (accounts) => {
    it('should have an empty game board at the beginning', async () => {
        console.log(accounts);
        const gameManager = await GameManager.deployed();
        // { tx, receipt, logs }
        const txReceipt = await gameManager.startNewGame({ value: web3.utils.toWei('0.1', 'ether') });
        console.log(txReceipt);
        const threeInARow = await ThreeInARow.at(txReceipt.logs[0].args._game);

        const board = await threeInARow.getBoard();

        for (let r = 0; r < 3; r++) {
            for (let c = 0; c < 3; c++) {
                assert.equal(0, board[r][c], `Row ${r+1} column ${c+1} must be zero`);
            }
        }
        
    });
});
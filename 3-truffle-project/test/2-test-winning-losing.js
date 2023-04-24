const GameManager = artifacts.require('GameManager');
const ThreeInARow = artifacts.require('ThreeInARow');

// Start ganache: ganache-cli
// Run test: truffle test
contract('ThreeInARow test win', (accounts) => {
    it('should should be possible to win the game diagonal', async () => {
        const gameManager = await GameManager.deployed();
        // { tx, receipt, logs }
        const txReceipt = await gameManager.startNewGame({ from: accounts[0], value: web3.utils.toWei('0.1', 'ether') });
        const threeInARow = await ThreeInARow.at(txReceipt.logs[0].args._game);
        const txReceiptJoin = await threeInARow.joinGame({ from: accounts[1], value: web3.utils.toWei('0.1', 'ether') }); 

        assert.equal('PlayerJoined', txReceiptJoin.logs[0].event);
        assert.equal('NextPlayer', txReceiptJoin.logs[1].event);
        
        let txReceiptPlayed = await threeInARow.setStone(0, 0, { from: txReceiptJoin.logs[1].args._player });
        txReceiptPlayed = await threeInARow.setStone(0, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 2, { from: txReceiptPlayed.logs[0].args._player });
        const winningPlayer = txReceiptPlayed.logs[0].args._player;
        txReceiptPlayed = await threeInARow.setStone(2, 2, { from: txReceiptPlayed.logs[0].args._player });

        // win
        assert.equal('PayoutSuccess', txReceiptPlayed.logs[0].event);
        assert.equal('GameOverWithWin', txReceiptPlayed.logs[1].event);
        assert.equal(txReceiptPlayed.logs[1].args._winner, winningPlayer);

        const winningAmount = (await threeInARow.gameCost.call()).mul(new web3.utils.BN(2));
        assert.deepEqual(web3.utils.toWei(txReceiptPlayed.logs[0].args._amountInWei), web3.utils.toWei(winningAmount));
        assert.equal(winningPlayer, txReceiptPlayed.logs[1].args._winner, 'The winner is not the winner');

        const board = await threeInARow.getBoard();
        assert.equal(winningPlayer, board[0][0], 'Left top is occupied by the winner');
        assert.equal(winningPlayer, board[1][1], 'Center is occupied by the winner');
        assert.equal(winningPlayer, board[2][2], 'Bottom right is occupied by the winner');
    });

    it('should should be possible to win the game anti diagonal', async () => {
        const gameManager = await GameManager.deployed();
        // { tx, receipt, logs }
        const txReceipt = await gameManager.startNewGame({ from: accounts[0], value: web3.utils.toWei('0.1', 'ether') });
        const threeInARow = await ThreeInARow.at(txReceipt.logs[0].args._game);
        const txReceiptJoin = await threeInARow.joinGame({ from: accounts[1], value: web3.utils.toWei('0.1', 'ether') }); 

        assert.equal('PlayerJoined', txReceiptJoin.logs[0].event);
        assert.equal('NextPlayer', txReceiptJoin.logs[1].event);
        
        let txReceiptPlayed = await threeInARow.setStone(2, 0, { from: txReceiptJoin.logs[1].args._player });
        txReceiptPlayed = await threeInARow.setStone(0, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 2, { from: txReceiptPlayed.logs[0].args._player });
        const winningPlayer = txReceiptPlayed.logs[0].args._player;
        txReceiptPlayed = await threeInARow.setStone(0, 2, { from: txReceiptPlayed.logs[0].args._player });

        // win
        assert.equal('PayoutSuccess', txReceiptPlayed.logs[0].event);
        assert.equal('GameOverWithWin', txReceiptPlayed.logs[1].event);
        assert.equal(txReceiptPlayed.logs[1].args._winner, winningPlayer);

        const winningAmount = (await threeInARow.gameCost.call()).mul(new web3.utils.BN(2));
        assert.deepEqual(web3.utils.toWei(txReceiptPlayed.logs[0].args._amountInWei), web3.utils.toWei(winningAmount));
        assert.equal(winningPlayer, txReceiptPlayed.logs[1].args._winner, 'The winner is not the winner');

        const board = await threeInARow.getBoard();
        assert.equal(winningPlayer, board[2][0], 'Bottom left is occupied by the winner');
        assert.equal(winningPlayer, board[1][1], 'Center is occupied by the winner');
        assert.equal(winningPlayer, board[0][2], 'Top right is occupied by the winner');
    });
    
    it('should should be possible to win the game horizontal', async () => {
        const gameManager = await GameManager.deployed();
        // { tx, receipt, logs }
        const txReceipt = await gameManager.startNewGame({ from: accounts[0], value: web3.utils.toWei('0.1', 'ether') });
        const threeInARow = await ThreeInARow.at(txReceipt.logs[0].args._game);
        const txReceiptJoin = await threeInARow.joinGame({ from: accounts[1], value: web3.utils.toWei('0.1', 'ether') }); 

        assert.equal('PlayerJoined', txReceiptJoin.logs[0].event);
        assert.equal('NextPlayer', txReceiptJoin.logs[1].event);
        
        let txReceiptPlayed = await threeInARow.setStone(0, 0, { from: txReceiptJoin.logs[1].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(0, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 2, { from: txReceiptPlayed.logs[0].args._player });
        const winningPlayer = txReceiptPlayed.logs[0].args._player;
        txReceiptPlayed = await threeInARow.setStone(0, 2, { from: txReceiptPlayed.logs[0].args._player });

        // win
        assert.equal('PayoutSuccess', txReceiptPlayed.logs[0].event);
        assert.equal('GameOverWithWin', txReceiptPlayed.logs[1].event);
        assert.equal(txReceiptPlayed.logs[1].args._winner, winningPlayer);

        const winningAmount = (await threeInARow.gameCost.call()).mul(new web3.utils.BN(2));
        assert.deepEqual(web3.utils.toWei(txReceiptPlayed.logs[0].args._amountInWei), web3.utils.toWei(winningAmount));
        assert.equal(winningPlayer, txReceiptPlayed.logs[1].args._winner, 'The winner is not the winner');

        const board = await threeInARow.getBoard();
        assert.equal(winningPlayer, board[0][0], 'Top left is occupied by the winner');
        assert.equal(winningPlayer, board[0][1], 'Center top is occupied by the winner');
        assert.equal(winningPlayer, board[0][2], 'Top right is occupied by the winner');
    });

    it('should should be possible to win the game vertical', async () => {
        const gameManager = await GameManager.deployed();
        // { tx, receipt, logs }
        const txReceipt = await gameManager.startNewGame({ from: accounts[0], value: web3.utils.toWei('0.1', 'ether') });
        const threeInARow = await ThreeInARow.at(txReceipt.logs[0].args._game);
        const txReceiptJoin = await threeInARow.joinGame({ from: accounts[1], value: web3.utils.toWei('0.1', 'ether') }); 

        assert.equal('PlayerJoined', txReceiptJoin.logs[0].event);
        assert.equal('NextPlayer', txReceiptJoin.logs[1].event);
        
        let txReceiptPlayed = await threeInARow.setStone(0, 0, { from: txReceiptJoin.logs[1].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 1, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 0, { from: txReceiptPlayed.logs[0].args._player });
        txReceiptPlayed = await threeInARow.setStone(1, 2, { from: txReceiptPlayed.logs[0].args._player });
        const winningPlayer = txReceiptPlayed.logs[0].args._player;
        txReceiptPlayed = await threeInARow.setStone(2, 0, { from: txReceiptPlayed.logs[0].args._player });

        // win
        assert.equal('PayoutSuccess', txReceiptPlayed.logs[0].event);
        assert.equal('GameOverWithWin', txReceiptPlayed.logs[1].event);
        assert.equal(txReceiptPlayed.logs[1].args._winner, winningPlayer);

        const winningAmount = (await threeInARow.gameCost.call()).mul(new web3.utils.BN(2));
        assert.deepEqual(web3.utils.toWei(txReceiptPlayed.logs[0].args._amountInWei), web3.utils.toWei(winningAmount));
        assert.equal(winningPlayer, txReceiptPlayed.logs[1].args._winner, 'The winner is not the winner');

        const board = await threeInARow.getBoard();
        assert.equal(winningPlayer, board[0][0], 'Top left is occupied by the winner');
        assert.equal(winningPlayer, board[1][0], 'Center left is occupied by the winner');
        assert.equal(winningPlayer, board[2][0], 'Bottom left is occupied by the winner');
    });
});
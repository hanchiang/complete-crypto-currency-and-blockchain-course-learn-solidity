pragma solidity >= 0.5.0 < 0.9.0;

contract Time {
    uint biddingStartTs = block.timestamp;
    uint biddingDays = 10 days;

    function getCurrentTs() public view returns(uint) {
        return block.timestamp;
    }

    function isBiddingStillOpen() public view returns(bool) {
        uint currentTs = getCurrentTs();
        return currentTs > biddingStartTs && currentTs <= biddingStartTs + biddingDays;
    }
}
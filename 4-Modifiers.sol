pragma solidity >= 0.5.0 < 0.9.0;

contract Modifiers {
    address public owner;
    uint myBalance;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Can only be called by owner");
        _;  // the called function body
    }

    function setOwner(address _address) onlyOwner public {
        owner = _address;
    }

    function payme() payable public {
        myBalance += msg.value;
    }

    function withdraw(address payable _to) onlyOwner public {
        _to.transfer(10**18);
    }
}
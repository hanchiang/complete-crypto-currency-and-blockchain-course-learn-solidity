pragma solidity >= 0.5.0 < 0.9.0;

contract GlobalObjects {
    address owner;
    uint myBalance;

    function setOwner(address _address) public {
        owner = _address;
    }

    function payme() payable public {
        myBalance += msg.value;
    }

    function withdraw(address payable _to) public {
        if (msg.sender == owner) {
            _to.transfer(10**18);
        }
    }
}
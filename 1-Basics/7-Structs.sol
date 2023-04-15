pragma solidity >= 0.5.0 < 0.9.0;

contract Struct {
    struct MyStruct  {
        uint balance;
        bool isSet;
        uint lastUpdated;
    }

    mapping(address => MyStruct) public myAddressMap;

    function deposit() public payable {
        myAddressMap[msg.sender].balance += msg.value;
        myAddressMap[msg.sender].isSet = true;
        myAddressMap[msg.sender].lastUpdated = block.timestamp;
    }

    function withdraw(address payable _to, uint amount) public payable {
        require(myAddressMap[msg.sender].balance >= amount, "Not enough balance");
        myAddressMap[msg.sender].balance -= amount;
        _to.transfer(amount);
    }
}
contract Mapping {
    mapping(address => bool) public myAddressBoolMap;
    mapping(address => uint) public myAddressBalanceMap;

    function writeBoolMap(address _address, bool _bool) public {
        myAddressBoolMap[_address] = _bool;
    }

    function writeBoolMap(bool _bool) public {
        myAddressBoolMap[msg.sender] = _bool;
    }

    function deposit() public payable {
        myAddressBalanceMap[msg.sender] += msg.value;
    }

    function withdraw(address payable _to, uint amount) public payable {
        require(myAddressBalanceMap[msg.sender] >= amount, "Not enough balance");
        myAddressBalanceMap[msg.sender] -= amount;
        _to.transfer(amount);
    }
}
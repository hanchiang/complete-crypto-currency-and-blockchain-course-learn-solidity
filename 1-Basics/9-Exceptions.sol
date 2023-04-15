pragma solidity >= 0.5.0 < 0.9.0;

contract Exceptions {
    bool isRunning = false;
    address owner;
    mapping(address => uint) public balanceMap;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function setRunning(bool _running) public onlyOwner {
        isRunning = _running;
    }

    function deposit() public payable {
        require(isRunning, "Contract is not running currently");
        balanceMap[msg.sender] += msg.value;
    }

    function withdraw(address payable _to, uint _amount) public payable {
        require(balanceMap[msg.sender] >= _amount, "Not enough balance");
        balanceMap[_to] -= _amount;
        // safety check in case the logic above is wrong
        require(balanceMap[msg.sender] < balanceMap[msg.sender] + _amount);
        _to.transfer(_amount);
    }
}
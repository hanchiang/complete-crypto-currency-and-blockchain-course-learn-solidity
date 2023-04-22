pragma solidity >= 0.5.0 < 0.9.0;

contract HelloWorld {
    string helloWorld = "Hello World";
    uint256 myInt;
    
    function setHelloWorld(string memory input) public {
        helloWorld = input;
    }

    function getHelloWorld() public view returns(string memory) {
        return helloWorld;
    }

    function setMyInt(uint256 input) public {
        myInt = input;
    }

    function killMe() public {
        selfdestruct(msg.sender);
    }
}
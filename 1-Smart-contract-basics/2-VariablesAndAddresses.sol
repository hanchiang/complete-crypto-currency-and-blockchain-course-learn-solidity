pragma solidity >= 0.5.0 < 0.9.0;

contract Variables {
    // Variables
   bool public myBool;
   uint8 public myUInt8 = 2**8-1;

   function setMyBool(bool input) public {
       myBool = input;
   }

   function uInt8WrapAround() public pure returns(uint8) {
       uint8 zeroInt = 0;
       zeroInt--;
       return zeroInt;
   }

   // Addresses

   address payable public myAddress;

   function setAddress(address payable input) public {
       myAddress = input;
   }

   function getTheBalance() public view returns(uint) {
       return myAddress.balance;
   }

   function payme() payable public {
   }

   function transferMoneyOut() public {
       myAddress.transfer(address(this).balance);
   }

   // Bytes
   bytes1 public myBytes1 = 0xFF;
   bytes32 public myBytes32 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

   function myBytesCompare() public view returns(bool) {
       return myBytes1 < myBytes32;
   }

   function getMyBytesLength() public view returns(uint8) {
       return myBytes1.length;
   }
}
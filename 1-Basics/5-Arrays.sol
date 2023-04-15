pragma solidity >= 0.5.0 < 0.9.0;

contract Arrays {
    uint[5] public arrayFixedSize;
    uint[] public arrayDynamicSize;
    uint[2][] public arrayFixedDynamic;

    function getFixed() view public returns(uint[5] memory) {
        return arrayFixedSize;
    }

    function getFixedDynamic() view public returns(uint[2][] memory) {
        return arrayFixedDynamic;
    }

    function getFixedDynamicLength() view public returns(uint, uint) {
        if (arrayFixedDynamic.length > 0) {
            return (arrayFixedDynamic.length, arrayFixedDynamic[0].length);
        }
    }

    function getDynamic() view public returns(uint[] memory) {
        return arrayDynamicSize;
    }

    function increaseFixedDynamicLength() public {
        arrayFixedDynamic.push();
        arrayFixedDynamic[arrayFixedDynamic.length-1][0] = 123;
        arrayFixedDynamic[arrayFixedDynamic.length-1][1] = 234;
    }

    function increaseDynamicLength() public {
        arrayDynamicSize.push();
        arrayDynamicSize[arrayDynamicSize.length-1] = 567; 
    }
}
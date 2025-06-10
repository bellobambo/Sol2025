// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Functions {

    uint256 public data ;
    uint256 public multiplier ;

    constructor (uint256 initialValue, uint256 initialMultiplier){
        data = initialValue;
        multiplier = initialMultiplier;
    }

    function setMultiplier(uint256 newMultiplier) external  returns (bool){
        multiplier =  newMultiplier;
        return  true;
    }

    function setData(uint256 newData) public returns (bool){
        data = newData;
        return  true;
    }

    function setComputedData(uint256 newData) external returns (bool){
        uint256 dataComputed = computeData(newData);
        return setData(dataComputed);
    }

    function computeData(uint256 someData) internal view returns(uint256){
        return someData * multiplier;
    }
}
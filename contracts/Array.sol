// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract Array {

    uint256[] public dynamicArray = [1,2, 3];


    bytes32 public slot0 = keccak256((abi.encode(0)));

    function addElementToDynamicArray(uint256 _newElement) external {
        dynamicArray.push(_newElement);
    }

}

// web3.eth.getStorageAt("0x0498B7c793D7432Cd9dB27fb02fc9cfdBAfA1Fd3", 4)
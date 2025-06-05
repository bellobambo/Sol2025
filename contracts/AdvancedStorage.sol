// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract AdvancedStorage{

    mapping (address => uint8) public ages;

    function register(address userAddress, uint8 age) external returns(bool){

        ages[userAddress] = age;
        return true;
    }

}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol";

contract Imports {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private visitors;

    function registerVisitor() external {
        visitors.add(msg.sender);
    }

    function numberOfVisitors() external view returns(uint){
        return visitors.length();
    }
}
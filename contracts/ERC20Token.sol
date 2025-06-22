// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";



contract MyERC20Token is ERC20{
    constructor (string memory _name, string memory _symbol) ERC20(_name, _symbol){
        _mint(msg.sender, 1 * 10**18);
        _mint(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 1 * 10**18);
    }
}
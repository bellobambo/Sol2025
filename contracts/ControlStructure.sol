// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "hardhat/console.sol";

contract ControlStructure{

    error InvalidNumber(); 

    function compareNumbers(uint256 _number1, uint256 _number2) external pure returns (string memory){
    
    // require(_number1 > 0 && _number2 > 0, "Invalid Inputs");

    if(_number1 == 0 && _number2 == 0){
        revert InvalidNumber();
    }

    if(_number1 > _number2){
        return  "Number 1 is greater than 2";
    }else if(_number1 < _number2 ){
        return  "Number 1 is less than 2" ;
    }else{
        return  "Numbers are equal ";
    }

  }

//   1121

  function loop() pure  external {
    for(uint256 index = 0; index < 8; index ++){
        console.log("The Index is", index);

        if(index == 2){
            console.log("Index is 2");
            continue;
        }
        console.log("After Index is 2");
         
        if(index == 5){
            console.log("Index is 4");
            break;
        }
        console.log("End of Loop");

    }
  }

}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

abstract contract ContractD{
    function whoAreYou() public virtual  returns (string memory);
}


contract ContractC{
    function whoAmI() public  virtual view returns (string memory){
        return "this is Contract C";
    }  
}

contract ContractB{
    function whoAmI() public virtual view returns (string memory){
        return "this is Contract B";
    }   

      function whoAmIInternal() internal pure returns (string memory){
        return "this is Contract B";
        
    }
}


contract ContractA is ContractB, ContractC, ContractD{
    enum Type {None, ContractBType, ContractCType}

    Type contractType;
    constructor(Type initialType){
        contractType = initialType;
    }

    function whoAmI() override(ContractB,ContractC ) public view returns (string memory){
        if(contractType == Type.ContractBType){
        return ContractB.whoAmI();
        }

        if (contractType == Type.ContractCType){
        return ContractC.whoAmI();

        }

        return "this is Contract A";
    }

    function changeType(Type newType) external {
        contractType = newType;
    }

    function whoAmIExternal() external  pure returns (string memory){
        return  whoAmIInternal();
    }


        function whoAreYou() pure public override returns (string memory){
        return  "A Person";
    }
    
}
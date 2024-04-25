//Manipulating memory
pragma solidity 0.8.24;

//Example
contract MyContract {
		function foo() external {
		    assembly {
			      let ptr := mload(0x40)
			       mstore(ptr, 10)
			       mstore(add(ptr, 0x20), 20)
			       let a := mload(ptr)            //10
			       let b := mload(add(ptr, 0x20)) //20
			       mstore(0x40, add(ptr, 0x40))   //only if some code is executed after
		    }
		}
}

//Return string
contract MyContract {
    function foo() external pure returns(string memory) {
        assembly {
            let str := "hey there"
            mstore(0x00, 0x20) //Offset - where in the return data the string starts
            mstore(0x20, 0x20) //then the length of the string
            mstore(0x40, str)  //the string to return in hex
            return(0, 0x60)
        }
    }
}

//Return in Solidity vs RETURN opcode
contract MyContract {
		//return Solidity => RETURN opcode
    function foo() external pure returns(string memory) {
		    string memory result = bar();
        return result;
    }
    //return Solidity => no RETURN opcode
     function bar() internal pure returns(string memory) {
        return "hey";
    }
}
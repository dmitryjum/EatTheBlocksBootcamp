//Interaction with Solidity variables & return
pragma solidity 0.8.24;

//Interaction with Solidity variables
contract MyContract {

	function foo() external {
		uint a;
		assembly {
		  let b := a //ok
		}
		uint c = b;//not ok
	}
}

//Return variables
pragma solidity 0.8.24;

contract MyContract {

	function foo() external pure returns(uint a) {
		assembly {
		  a := 1
		}
	}
}
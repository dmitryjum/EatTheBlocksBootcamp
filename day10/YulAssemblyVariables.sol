//Variable declaration
pragma solidity 0.8.24;

//Declaration of assembly block
contract MyContract {
	function foo() {
		assembly {
		}
	}
}

//Declaration of variable
contract MyContract {
	assembly {
	  let a
	  a := 1
	}
}

//3 types of literal
contract MyContract {
	assembly {
	  let a := 1
	  let b := "hey":
	  let c := hex"9813913"
	}
}

//Exercisae: Declare an assembly block with variables a, b, c, initialized to 1, 2, 3
//solution
pragma solidity 0.8.24;

contract MyContract {
	assembly {
	  let a := 1
	  let b := 2
	  let c := 3
	}
}
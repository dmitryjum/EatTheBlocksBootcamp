
//Using built-in functions

pragma solidity 0.8.24;

contract MyContract {
	assembly {
	  let a := add(1, 2)
	  let b := sub(2, 1)
	  let c := add(add(a, b), 1)
	  let d = address()
	}
}
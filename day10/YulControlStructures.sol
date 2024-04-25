//Control structures
pragma solidity 0.8.24;

//If
contract MyContract {
    function foo(uint a) external {
        assembly {
		        if lt(a, 0) {
		            //do something
	          }
	          if gt(a, 0) {
		            //do something else
	          }
	          if eq(a, 10) {
		            //do something else
	          }
	          if iszero(a, 0) {
				         // something
		        }
        }
    }
}

//Switch
contract MyContract {
		function foo(uint a) external {
				assembly {
						switch a
					  case 0 {
				        //Do something
					  }
					  case 1 {
				        //Do something else
					  }
					  default {
							  //Do something else
					  }
				}
		}
}

//Exercise: Create a smart contract with a function that tells if a number if odd or not
//Solution
contract MyContract {
		function idOdd(uint a) external pure returns(bool result) {
				assembly {
						switch mod(a, 2)
					  case 0 {
				        result := true
					  }
					  default {
							  result := false
					  }
				}
		}
}

//For loops
contract MyContract {
		function foo() external {
				assembly {
		        for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
		            //do something
				    }
				}
		}
}

//Exercise: Create an implementation of power function(base, exponent)
//Solution
contract MyContract {
		function power(uint base, uint exponent) external pure returns(uint result) {
				assembly {
		        result := 1
		        for { let i := 0 } lt(i, exponent) { i := add(i, 1) } {
		            result := mul(result, base)
				    }
				}
		}
}
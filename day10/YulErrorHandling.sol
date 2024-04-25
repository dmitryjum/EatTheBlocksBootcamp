//Dealing with errors
pragma solidity 0.8.24;

//Simple revert
contract MyContract {
    function foo(uint a) external {
        assembly {
		        if iszero(a) { 
	            revert(0, 0)
	          }
        }
    }
}

//Revert, with reason
contract MyContract {
    function foo(uint a) external {
        assembly {
            if iszero(a) { 
                //need to create abi encoding for `function Error(string memory reason) external;`
                let ptr := mload(0x40)
                mstore(ptr, shl(229, 4594637)) //function selector. Bitshiting is to pad the select to make it 32 bytes
                mstore(add(ptr, 0x04), 0x20)   // Offset - bytes index at which the data starts
                mstore(add(ptr, 0x24), 3)      // String length
                mstore(add(ptr, 0x44), "abc")
                revert(ptr, add(ptr, 0x64)).   //Covers function selector, offset, string length, and 32 bytes for the string
	        }
        }
    }
}

//Exercise: rewrite this contract in Yul
contract Counter {
    uint private count;

    function increment() public {
        count += 1;
    }

    function decrement() public {
        require(count > 0, "Counter: cannot decrement below 0");
        count -= 1;
    }

    function reset() public {
        count = 0;
    }

    function getCount() public view returns (uint) {
        return count;
    }
}

//Solution
contract Counter {
    uint256 private count;

    function increment() public {
        assembly {
            let _count := sload(count.slot)
            _count := add(_count, 1)
            sstore(count.slot, _count)
        }
    }

    function decrement() public {
        assembly {
            let _count := sload(count.slot)
            if iszero(gt(_count, 0)) {
		            let ptr := mload(0x40)
                mstore(ptr, shl(229, 4594637)) //function selector
                mstore(add(ptr, 0x04), 0x20)   // Offset - bytes index at which the data starts
                mstore(add(ptr, 0x24), 24)      // String length
                mstore(add(ptr, 0x44), "Cannot decrement below 0")
                revert(ptr, add(ptr, 0x64))
                //revert(0, 0)
            }
            _count := sub(_count, 1)
            sstore(count.slot, _count)
        }
    }

    function reset() public {
        assembly {
            sstore(count.slot, 0)
        }
    }

    function getCount() public view returns (uint currentCount) {
        assembly {
            currentCount := sload(count.slot)
        }
    }
}
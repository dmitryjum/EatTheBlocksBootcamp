//Manipulation storage
pragma solidity 0.8.24;

//How to write to storage
contract MyContract {
	function foo() external {
		assembly {
		  sstore(0, 1)
	}
}

//How to read from storage
contract MyContract {
	function foo() external {
		assembly {
		  let a := sload(0)
	}
}

//Exercise: rewrite this contract in Assembly
contract SimpleStorage {
    uint private data;

    function setData(uint _data) external {
        data = _data;
    }

    function getData() external view returns(uint) {
        return data;
    }
}

//Solution
contract SimpleStorage {
		uint private data;
    function setData(uint _data) external {
        assembly {
            sstore(data.slot, _data)
        }
    }

    function getData() external view returns (uint data) {
        assembly {
            data := sload(data.slot)
        }
    }
}
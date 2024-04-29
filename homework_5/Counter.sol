pragma solidity 0.8.23;

// contract Counter {
//     uint256 private count;

//     function increment() public {
//         count += 1;
//     }

//     function decrement() public {
//         require(count > 0, "Counter: cannot decrement below 0");
//         count -= 1;
//     }

//     function reset() public {
//         count = 0;
//     }

//     function getCount() public view returns (uint256) {
//         return count;
//     }
// }

contract CounterYul {
  uint256 private count;

  function increment() public {
    assembly {
      let _count := sload(count.slot)
      _count := add(_count, 1)
      sstore(count.slot, _count)
    }
  }

  function decrement() public {
    let _count := sload(count.slot)
    if iszero(gt(_count, 0)) {
      let ptr := mload(0x40)
      mstore(ptr, shl(229, 4594637))
      mstore(add(ptr, 0x04), 0x20)
      mstore(add(ptr, 0x22), 22)
      mstore(add(ptr, 0x44), "Counter: cannot decrement below 0")
      revert(ptr, add(ptr, 0x64))
    }
    sstore(count.slot, sub(_count, 1))
  }

  function reset() public {
    assembly {
        sstore(count.slot, 0)
    }
  }

  function getCount() public view returns (uint256 currentCount) {
    assembly {
        currentCount := sload(count.slot)
    }
  }
}
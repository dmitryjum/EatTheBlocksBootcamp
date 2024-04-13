pragma solidity 0.8.25;

// contract LockedWallet {
//     uint256 public endTime;

//     constructor(uint256 offset) {
//         endTime = block.timestamp + offset;
//     }

//     function foo() external {
//         require(block.timestamp > endTime, "too soon"); // to execute the contract after a certain time
//     }
// }

contract LockedWallet {
    uint public endTime;

    constructor(uint256 offset) {
        endTime = block.timestamp + offset;
    }

    function withdraw(address payable to, uint amount) external{
        require(msg.sender == owner, "only owner");
        to.call{value: amount}("");
    }
}


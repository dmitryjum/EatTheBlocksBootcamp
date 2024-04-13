pragma solidity 0.8.25;

contract MyStorage {
    uint256 public someData;

    function changeData(uint256 newData) external {
        someData = newData;
    }

    function deposit() external payable {
        // empty body
    }
}
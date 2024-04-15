pragma solidity 0.8.25;

interface IMyStorage {
    function changeData(uint256 newData) external;
    function deposit(uint256 newData) external;
}
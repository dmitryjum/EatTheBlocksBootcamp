// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

interface IWallet {
    function deposit() external payable;
    function withdraw() external;
    function balances(address) external view returns (uint256);
}
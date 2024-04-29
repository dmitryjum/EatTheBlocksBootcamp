// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

interface IVault {
    function withdraw(address recipient) external;
    function owner() external view;
}
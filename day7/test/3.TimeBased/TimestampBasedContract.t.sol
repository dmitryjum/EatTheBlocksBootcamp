// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TimestampBasedContract} from "../../src/3.TimeBased/TimestampBasedContract.sol";

contract TimestampBasedContractTest is Test {
    TimestampBasedContract public timsetampBasedContract;

    uint256 minTimestamp = 1714514400;

    function setUp() public {
        timsetampBasedContract = new TimestampBasedContract(minTimestamp);
    }

    function test_SetNumber() public {
        uint256 newNumber = 10;
        vm.warp(minTimestamp);
        timsetampBasedContract.setNumber(newNumber);

        assertEq(timsetampBasedContract.number(), newNumber);
    }
}
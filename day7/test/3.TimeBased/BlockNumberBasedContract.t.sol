// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {BlockNumberBasedContract} from "../../src/3.TimeBased/BlockNumberBasedContract.sol";

contract BlockNumberBasedContractTest is Test {
    BlockNumberBasedContract public blockNumberBasedContract;

    uint256 minBlockNumber = 10000;

    function setUp() public {
        blockNumberBasedContract = new BlockNumberBasedContract(minBlockNumber);
    }

    function test_SetNumber() public {
        uint256 newNumber = 10;
        vm.roll(minBlockNumber);
        blockNumberBasedContract.setNumber(newNumber);

        assertEq(blockNumberBasedContract.number(), newNumber);
    }
}
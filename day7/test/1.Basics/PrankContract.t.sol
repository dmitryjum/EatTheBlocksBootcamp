// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {PrankContract} from "../../src/1.Basics/PrankContract.sol";

contract PrankContractTest is Test {
    PrankContract public prankContract;

    address owner = address(1);

    function setUp() public {
        prankContract = new PrankContract(owner);
    }

    function test_Increment() public {
        uint256 newNumber = 2;
        vm.startPrank(owner);
        prankContract.increment();
        prankContract.increment();
        assertEq(prankContract.number(), newNumber);
    }
}
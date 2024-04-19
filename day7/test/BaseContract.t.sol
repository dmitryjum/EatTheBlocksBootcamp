// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {BaseContract} from "../src/BaseContract.sol";

contract BaseContractTest is Test {
    BaseContract public baseContract;

    function setUp() public {
        baseContract = new BaseContract();
    }


    function test_Increment() public {
        // Arrange
        uint256 expectedValue = 1;

        // Act
        baseContract.increment();

        // Assert
        uint256 currentNumber = baseContract.number();
        assert(currentNumber == expectedValue);
    }

    function test_InitialValues() public {
        // Arrange
        uint256 expectedValue = 1;

        // Assert 
        uint256 currentArrayNumber = baseContract.array(0);
        uint256 currentSimpleMappingNumber = baseContract.simpleMapping(0);
        uint256 currentNestedMappingNumber = baseContract.nestedMapping(0, 0);

        assertTrue(currentArrayNumber == expectedValue);
        assertTrue(currentSimpleMappingNumber == expectedValue);
        assertEq(currentNestedMappingNumber, expectedValue);
    }
}
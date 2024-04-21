// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ErrorContract} from "../../src/1.Basics/ErrorContract.sol";

contract ErrorContractTest is Test {
    ErrorContract public errorContract;

    uint256 public requiredMinNumber = 10;

    function setUp() public {
        errorContract = new ErrorContract(requiredMinNumber);
    }

    function test_SetNumber() public {
        uint256 newNumber = requiredMinNumber + 1;
        errorContract.setNumber(newNumber);

        assertEq(errorContract.number(), newNumber);
    }

    function test_RevertWhen_NumberLessThanMin() public {
        uint256 newNumber = requiredMinNumber - 1;
        vm.expectRevert(abi.encodeWithSelector(ErrorContract.InvalidNumber.selector, newNumber, requiredMinNumber));

        errorContract.setNumber(newNumber);
    }

     function test_RevertWhen_NumberLessThanMin2() public {
        uint256 newNumber = requiredMinNumber - 1;
        vm.expectRevert(ErrorContract.InvalidNumber2.selector);

        errorContract.setNumber2(newNumber);
    }

    function test_RevertWhen_NumberLessThanMin3() public {
        uint256 newNumber = requiredMinNumber - 1;
        vm.expectRevert("number not big enough");

        errorContract.setNumber3(newNumber);
    }
}
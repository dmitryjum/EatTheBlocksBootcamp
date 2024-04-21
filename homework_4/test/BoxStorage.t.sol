// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {BoxStorage} from "../src/BoxStorage.sol";

contract BoxStorageTest is Test {
    BoxStorage public boxStorage;

    uint256 minimumSizeInCm = 10;

    function setUp() public {
        boxStorage = new BoxStorage(minimumSizeInCm);
    }

    function test_CreateBox() public {
        // finish this test
    }

    function test_RevertWhen_WidthLessThanMinimum() public {
        uint256 width = minimumSizeInCm - 1;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongWidth.selector, width, minimumSizeInCm));

        boxStorage.createBox(width, length, height);    
    }

    function test_RevertWhen_LengthLessThanMinimum() public {
        // finish this test
    }

    function test_RevertWhen_HeightLessThanMinimum() public {
        // finish this test
    }
}
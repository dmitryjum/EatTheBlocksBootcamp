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
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm;
        boxStorage.createBox(width, length, height);
        // (uint256 retrievedWidth, uint256 retrievedLength, uint256 retrievedHeight) = boxStorage.boxes(0);
        BoxStorage.Box memory returnedBox = boxStorage.getBox(0);
        assertEq(returnedBox.width, minimumSizeInCm);
        assertEq(returnedBox.height, minimumSizeInCm);
        assertEq(returnedBox.length, minimumSizeInCm);
    }

    function test_RevertWhen_WidthLessThanMinimum() public {
        uint256 width = minimumSizeInCm - 1;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongWidth.selector, width, minimumSizeInCm));

        boxStorage.createBox(width, length, height);    
    }

    function test_RevertWhen_LengthLessThanMinimum() public {
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm - 1;
        uint256 height = minimumSizeInCm;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongLength.selector, length, minimumSizeInCm));

        boxStorage.createBox(width, length, height);
    }

    function test_RevertWhen_HeightLessThanMinimum() public {
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm - 1;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongHeight.selector, height, minimumSizeInCm));

        boxStorage.createBox(width, length, height);
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {CharityBaseTest} from "./CharityBase.t.sol";

contract CharityCanDonateTest is CharityBaseTest {
    /*
        CanDonate:
        Returns true when not reached deadline
        Returns false when reached deadline
    */

    function test_CanDonate_ReturnsTrue() public view {
        bool canDonate = charity.canDonate();
        assertTrue(canDonate);
    }

    function test_CanDonate_ReturnsFalse() public {
        uint256 deadline = charity.moneyCollectingDeadline();
        vm.warp(deadline);
        bool canDonate = charity.canDonate();
        assertFalse(canDonate);
    }
}

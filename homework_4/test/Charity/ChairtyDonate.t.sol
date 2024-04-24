// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Charity} from "../../src/Charity.sol";
import {CharityBaseTest} from "./CharityBase.t.sol";

contract CharityDonateTest is CharityBaseTest {
    /*
        Donate:
        Test donate - happy path
        Test can not donate anymore - unhappy path
        Test not enough donation amount - unhappy path
    */

    function test_Donate() public {
        uint256 expectedDonatedAmount = donationAmount;
        vm.expectEmit(true, true, true, true);
        emit Donated(donator, expectedDonatedAmount);

        deal(donator, expectedDonatedAmount);
        _donate(address(donator), expectedDonatedAmount);

        assertEq(address(charity).balance, expectedDonatedAmount);
        assertEq(charity.userDonations(donator), expectedDonatedAmount);
    }

    function test_RevertWhen_CanNotDonateAnymore() public {
        uint256 deadlineTimestamp = charity.moneyCollectingDeadline();
        vm.expectRevert(Charity.CanNotDonateAnymore.selector);
        vm.warp(deadlineTimestamp);

        _donate(address(this), 0);
    }

    function test_RevertWhen_NotEnoughDonationAmount() public {
        vm.expectRevert(Charity.NotEnoughDonationAmount.selector);

        _donate(address(this), 0);
    }
}
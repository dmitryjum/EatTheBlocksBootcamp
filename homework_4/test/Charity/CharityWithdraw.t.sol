// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Charity} from "../../src/Charity.sol";
import {CharityBaseTest} from "./CharityBase.t.sol";
import {FakeOwner} from "../FakeOwner.sol";

contract CharityWithdrawTest is CharityBaseTest {
    /*
        Withdraw:
        Test withdraw - happy path
        Test when not owner - unhappy path
        Test when not enough money - unhappy path
        Test when transfer failed - unhappy path
    */

    function setUp() public override {
        super.setUp();
        deal(address(charity), donationAmount);
    }

    function test_Withdraw() public {
        uint256 expectedDonatedAmount = donationAmount;
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(expectedDonatedAmount);

        _withdraw(owner, expectedDonatedAmount);

        assertEq(address(charity).balance, 0);
        assertEq(owner.balance, expectedDonatedAmount);
    }

    function test_RevertWhen_NotOwner() public {
        vm.expectRevert(Charity.NotOwner.selector);
        _withdraw(address(this), donationAmount);
    }

    function test_RevertWhen_NotEnoughMoney() public {
        vm.expectRevert(Charity.NotEnoughMoney.selector);
        _withdraw(owner, donationAmount + 1);
    }

    function test_RevertWhen_TransferFailed() public {
        FakeOwner fakeOwner = new FakeOwner();
        charity = new Charity(address(fakeOwner), moneyCollectingDeadline);

        deal(address(charity), donationAmount);

        vm.expectRevert(Charity.TransferFailed.selector);
        _withdraw(address(fakeOwner), donationAmount);
    }
}
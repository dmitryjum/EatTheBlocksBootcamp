// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../../src/Wallet.sol";
import {WalletBaseTest} from "./WalletBase.t.sol";

contract WalletDepositTest is WalletBaseTest {
    /*
        Donate:
        Test donate with donation - happy path
        Test donate without donation - happy path
        Test can not deposit zero ethers - unhappy path
    */

    function test_Deposit_WithDonation() public {
        uint256 expectedDonatedAmount = (depositAmount * charityPercentage) / 1000;
        uint256 expectedDepositAmount = depositAmount - expectedDonatedAmount;

        _deposit(address(this), depositAmount);

        assertEq(address(charity).balance, expectedDonatedAmount);
        assertEq(address(wallet).balance, expectedDepositAmount);
    }

    function test_Deposit_WithoutDonation() public {
        uint256 expectedDonatedAmount = 0;
        uint256 expectedDepositAmount = depositAmount;
        uint256 charityDeadline = charity.moneyCollectingDeadline();
        vm.warp(charityDeadline);

        _deposit(address(this), depositAmount);

        assertEq(address(charity).balance, expectedDonatedAmount);
        assertEq(address(wallet).balance, expectedDepositAmount);
    }

    function test_RevertWhen_CanNotDepositZeroEthers() public {
        vm.expectRevert(Wallet.CanNotDepositZeroEthers.selector);

        _deposit(address(this), 0);
    }
}
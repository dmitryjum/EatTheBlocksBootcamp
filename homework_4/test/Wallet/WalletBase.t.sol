// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Charity} from "../../src/Charity.sol";
import {Wallet} from "../../src/Wallet.sol";

abstract contract WalletBaseTest is Test {
    Charity public charity;
    Wallet public wallet;

    uint256 public moneyCollectingDeadline = 10 days;
    address owner = address(1);
    uint256 depositAmount = 1 ether;
    uint256 charityPercentage = 50;

    function setUp() public virtual {
        charity = new Charity(owner, moneyCollectingDeadline);
        wallet = new Wallet(owner, address(charity), charityPercentage);
    }

    function _deposit(address from, uint256 amount) internal {
        vm.prank(from);
        wallet.deposit{value: amount}();
    }

    function _withdraw(address from, uint256 amount) internal {
        vm.prank(from);
        wallet.withdraw(amount);
    }
}
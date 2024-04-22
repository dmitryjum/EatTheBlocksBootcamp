// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";
import {Charity} from "../src/Charity.sol";

contract WalletTest is Test {
  Wallet public wallet;
  address owner = address(1);
  address charityAddress;
  uint256 charityPercentage;
  uint256 depositAmount;
  Charity public charity;

  function setUp() public {
    charity = new Charity(owner, 2 days);
    charityAddress = address(charity);
    charityPercentage = 10;
    wallet = new Wallet(owner, charityAddress, charityPercentage);
  }

  function test_deposit() public {
    depositAmount = 5 ether;
    hoax(owner, depositAmount);
    wallet.deposit{value: depositAmount}();
    uint256 charityBalance = address(charity).balance;
    uint256 expectedCharityAmount = (depositAmount * charityPercentage) / 1000;
    assertEq(charityBalance, expectedCharityAmount);
  }

  function test_depositWhenCanNotDonate() public {
    vm.warp(block.timestamp + 3 days);
    depositAmount = 5 ether;
    hoax(owner, depositAmount);
    wallet.deposit{value: depositAmount}();
    uint256 charityBalance = address(charity).balance;
    assertEq(charityBalance, 0);
  }

  function test_withdraw() public {
    vm.prank(owner);
    deal(address(wallet), 4 ether);
    wallet.withdraw(4 ether);
    assertEq(address(wallet).balance, 0 ether);
  }

  function test_RevertCanNotDepositZeroEthers() public {
    depositAmount = 0 ether;
    vm.expectRevert(abi.encodeWithSelector(Wallet.CanNotDepositZeroEthers.selector));

    hoax(owner, depositAmount);
    wallet.deposit{value: depositAmount}();
  }

  function test_withdrawRevertNotOwner() public {
    vm.expectRevert(abi.encodeWithSelector(Wallet.NotOwner.selector));
    wallet.withdraw(5 ether);
  }

  function test_withdrawRevertNotEnoughMoney() public {
    vm.expectRevert(abi.encodeWithSelector(Wallet.NotEnoughMoney.selector));
    vm.prank(owner);
    wallet.withdraw(5 ether);
  }
}
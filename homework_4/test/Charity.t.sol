// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Charity} from "../src/Charity.sol";

contract CharityTest is Test {
  Charity public charity;
  address owner = address(1);
  address donator;
  uint256 donationAmount;
  event Donated(address indexed donator, uint256 amount);
  event Withdrawn(uint256 amount);
  
  mapping(address => uint256) public userDonations;

  function setUp() public {
    donator = address(0x1);
  }

  function test_canDonate() public {
    charity = new Charity(owner, 2 days);
    assertTrue(charity.canDonate());
  }

  function test_canNotDonate() public {
    charity = new Charity(owner, 0 days);
    assertFalse(charity.canDonate());
  }

  function test_donate() public {
    donationAmount = 10 ether;
    charity = new Charity(owner, 2 days);
    hoax(donator, donationAmount);
    vm.expectEmit(true, true, true, true);
    emit Donated(donator, donationAmount);
    charity.donate{value: donationAmount}();
    uint256 currentBalance = address(charity).balance;

    assertEq(currentBalance, donationAmount);
    assertEq(charity.userDonations(donator), donationAmount);
  }

  function test_withdraw() public {
    charity = new Charity(owner, 2 days);
    vm.prank(owner);
    deal(address(charity), 4 ether);
    vm.expectEmit(true, true, true, true);
    emit Withdrawn(4 ether);
    charity.withdraw(4 ether);
    assertEq(address(charity).balance, 0 ether);
  }

  function test_RevertWhen_CanNotDonateAnymore() public {
    donationAmount = 10 ether;
    charity = new Charity(owner, 0 days);
    vm.expectRevert(abi.encodeWithSelector(Charity.CanNotDonateAnymore.selector));
    hoax(donator, donationAmount);
    charity.donate{value: donationAmount}();
  }

  function test_RevertWhenNotEnoughDonationAmount() public {
    donationAmount = 0 ether;
    charity = new Charity(owner, 2 days);
    vm.expectRevert(abi.encodeWithSelector(Charity.NotEnoughDonationAmount.selector));
    hoax(donator, donationAmount);
    charity.donate{value: donationAmount}();
  }

  function test_RevertNotOwner() public {
    charity = new Charity(owner, 2 days);
    vm.expectRevert(abi.encodeWithSelector(Charity.NotOwner.selector));
    charity.withdraw(5 ether);
  }

  function test_RevertNotEnoughMoney() public {
    charity = new Charity(owner, 2 days);
    vm.expectRevert(abi.encodeWithSelector(Charity.NotEnoughMoney.selector));
    vm.prank(owner);
    deal(address(charity), 4 ether);
    charity.withdraw(5 ether);
  }
  
}
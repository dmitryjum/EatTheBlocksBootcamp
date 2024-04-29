// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {Test} from "forge-std/Test.sol";
import {AttackingContract} from "../../src/Reentrancy/AttackingContract.sol";
import {Wallet} from "../../src/Reentrancy/Wallet.sol";

contract AttackingContractTest is Test {
    Wallet public wallet;
    AttackingContract public attackingContract;

    address _attacker = address(1);

    function setUp() public {
        wallet = new Wallet();
        vm.prank(_attacker);
        attackingContract = new AttackingContract(address(wallet));
    }

    function sendValue(address recipient, uint256 amount) private {
        (bool success,) = payable(recipient).call{value: amount}("");
        assertTrue(success);
    }

    function test_Attack() public {
        deal(_attacker, 1 ether);

        uint256 startAttackerBalance = _attacker.balance;
        uint256 startAttackerContractBalance = address(attackingContract).balance;
        uint256 startWalletContractBalance = address(wallet).balance;

        wallet.deposit{ value: 10.5 ether }();

        vm.startPrank(_attacker);
        vm.expectRevert();
        attackingContract.gIvEmEYoUrMoNeY{value: 1 ether}();
    }
}
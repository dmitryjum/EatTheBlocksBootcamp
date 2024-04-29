// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {Test} from "forge-std/Test.sol";
import {AttackingContract} from "../../src/TxOrigin/AttackingContract.sol";
import {Vault} from "../../src/TxOrigin/Vault.sol";

contract AttackingContractTest is Test {
    Vault public vault;
    AttackingContract public attackingContract;

    address _attacker = address(1);
    uint256 _amount = 1 ether;

    function setUp() public {
        vault = new Vault();
        sendValue(address(vault), _amount);
        vm.prank(_attacker);
        attackingContract = new AttackingContract(address(vault));
    }

    function sendValue(address recipient, uint256 amount) private {
        (bool success,) = payable(recipient).call{value: amount}("");
        assertTrue(success);
    }

    function test_Attack() public {
        uint256 startAttackerBalance = _attacker.balance;
        uint256 startAttackerContractBalance = address(attackingContract).balance;
        uint256 startVaultContractBalance = address(vault).balance;

        sendValue((address(attackingContract)), 1);

        uint256 endAttackerBalance = _attacker.balance;
        uint256 endAttackerContractBalance = address(attackingContract).balance;
        uint256 endVaultContractBalance = address(vault).balance;

        assertEq(endAttackerBalance, startAttackerBalance + _amount);
        assertEq(endVaultContractBalance, 0);
    }
}
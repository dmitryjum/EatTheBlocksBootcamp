// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import {AttackingContract} from "../src/AttackingContract.sol";
import {DecentralizedCrowdfunding} from "../src/DecentralizedCrowdfunding.sol";

contract AttackingContractTest is Test {
    AttackingContract public attackingContract;
    DecentralizedCrowdfunding public decentralizedCrowdfunding;

    uint256 legalContribution = 10 ether;
    uint256 legalGoal = 20 ether;
    uint256 legalDuration = 1 days;

    uint256 attackingContribution = 1 ether;
    uint256 attackingGoal = 2 ether;
    uint256 attackingDuration = 30 minutes;
    uint256 attackingDeadline = block.timestamp + attackingDuration;

    function setUp() public {
        decentralizedCrowdfunding = new DecentralizedCrowdfunding();
        attackingContract = new AttackingContract(address(decentralizedCrowdfunding));
    }

    function test_ReverIf_CheckEffectInteractionIsPresent() public {
        // Legal actions, which will rise some amount to withdraw by attacker
        decentralizedCrowdfunding.createCampaign(legalGoal, legalDuration);
        decentralizedCrowdfunding.contribute{value: legalContribution}(decentralizedCrowdfunding.numCampaigns());

        // Attacker actions
        attackingContract.prepareAttack{value: attackingContribution}(attackingGoal, attackingDuration);
        vm.warp(attackingDeadline);
        vm.expectRevert(DecentralizedCrowdfunding.TransferFailed.selector);
        attackingContract.attack();
    }
}
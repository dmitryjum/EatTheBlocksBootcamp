// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import {DecentralizedCrowdfunding} from "../src/DecentralizedCrowdfunding.sol";

contract DecentralizedCrowdfundingBaseTest is Test {
    DecentralizedCrowdfunding public decentralizedCrowdfunding;

    uint256 campaignId = 1;
    address owner = address(this);
    uint256 goal = 10 ether;
    uint256 duration = 30 days;
    uint256 deadline = block.timestamp + duration;

    address contributor = address(1);
    uint256 contributeAmount = 1 ether;

    function setUp() public virtual {
        decentralizedCrowdfunding = new DecentralizedCrowdfunding();
    }

    function createCampaign(uint256 _goal, uint256 _duration) internal {
        decentralizedCrowdfunding.createCampaign(_goal, _duration);
    }

    function contribute(uint256 _campaignId, uint256 _amount) internal {
        decentralizedCrowdfunding.contribute{value: _amount}(_campaignId);
    }

    function claimFunds(uint256 _campaignId) internal {
        decentralizedCrowdfunding.claimFunds(_campaignId);
    }

    function withdrawContribution(uint256 _campaignId) internal {
        decentralizedCrowdfunding.withdrawContribution(_campaignId);
    }

    receive() external payable {}
}

contract CreateCampaignTest is DecentralizedCrowdfundingBaseTest {
    /*
    createCampaign:

    Test creating campaign with valid params.
    Test creating campaign with goal == 0.
    Test creating campaign with duration param causing overflow.
    */
    event CampaignCreated(uint256 indexed campaignId, address owner, uint256 goal, uint256 deadline);

    function setUp() public override {
        super.setUp();
    }

    function test_CreateCampaign() public {
        vm.expectEmit(true, true, true, true);
        emit CampaignCreated(campaignId, owner, goal, deadline);
        createCampaign(goal, duration);

        (address _owner, uint256 _goal, uint256 _deadline, uint256 _fundsRaised, bool _claimed) =
            decentralizedCrowdfunding.campaigns(campaignId);
        assertEq(_owner, owner);
        assertEq(_goal, goal);
        assertEq(_deadline, deadline);
        assertEq(_fundsRaised, 0);
        assertFalse(_claimed);
    }

    function test_RevertIf_GoalEqualsZero() public {
        vm.expectRevert(DecentralizedCrowdfunding.InvalidGoal.selector);
        createCampaign(0, duration);
    }

    function test_RevertIf_DurationCouldCauseOverflow() public {
        vm.expectRevert(stdError.arithmeticError);
        createCampaign(goal, type(uint256).max);
    }
}

contract ContributeTest is DecentralizedCrowdfundingBaseTest {
    /*
    contribute:

    Contribute to existing campaign with valid params.
    Contribute to non existing campaign.
    Contribute to existing campaign which has ended.
    Contribute to existing campaign with 0 value.
    */
    event ContributionMade(uint256 indexed campaignId, address contributor, uint256 amount);

    function setUp() public override {
        super.setUp();
        createCampaign(goal, duration);
    }

    function test_Contribute() public {
        vm.expectEmit(true, true, true, true);
        emit ContributionMade(campaignId, contributor, contributeAmount);
        hoax(contributor, contributeAmount);
        contribute(campaignId, contributeAmount);
        uint256 contractBalance = address(decentralizedCrowdfunding).balance;

        (,,, uint256 _fundsRaised,) = decentralizedCrowdfunding.campaigns(campaignId);
        assertEq(_fundsRaised, contributeAmount);
        assertEq(contractBalance, contributeAmount);
    }

    function test_RevertIf_CampaignNotExists() public {
        vm.expectRevert("Campaign not exists");
        contribute(type(uint256).max, contributeAmount);
    }

    function test_RevertIf_ContributeZeroEthers() public {
        vm.expectRevert(DecentralizedCrowdfunding.InvalidContribution.selector);
        contribute(campaignId, 0);
    }

    function test_RevertWhen_CampaignHasEnded() public {
        vm.expectRevert(DecentralizedCrowdfunding.CampaignEnded.selector);
        vm.warp(deadline);
        contribute(campaignId, contributeAmount);
    }
}

contract ClaimFundsTest is DecentralizedCrowdfundingBaseTest {
    /*
    claimFunds:

    Claim funds from existing campaign which address is owner, campaign reached the goal and campaign ended.
    Claim funds from non existing campaign.
    Claim funds from existing campaign which address is not owner.
    Claim funds from existing campaign which address is owner, campaign reached the goal and campaign not ended.
    Claim funds from existing campaign which address is owner, campaign not reached the goal.
    Claim funds from existing campaign which address is owner, campaign reached the goal, 
    campaign ended and funds are already claimed.
    */
    event FundsClaimed(uint256 indexed campaignId, uint256 amount);

    function setUp() public override {
        super.setUp();
        createCampaign(goal, duration);
    }

    function test_ClaimFunds() public {
        deal(owner, goal);
        contribute(campaignId, goal);
        uint256 startBalance = address(this).balance;

        vm.warp(deadline);

        vm.expectEmit(true, true, true, true);
        emit FundsClaimed(campaignId, goal);
        claimFunds(campaignId);

        uint256 endBalance = address(this).balance;

        (,,,, bool _claimed) = decentralizedCrowdfunding.campaigns(campaignId);
        assertTrue(_claimed);
        assertEq(startBalance, 0);
        assertEq(endBalance, goal);
    }

    function test_RevertIf_CampaignNotExists() public {
        vm.expectRevert("Campaign not exists");
        claimFunds(type(uint256).max);
    }

    function test_RevertWhen_NotOwnerOfCampaign() public {
        vm.expectRevert(DecentralizedCrowdfunding.NotOwnerOfCampaign.selector);
        vm.prank(address(type(uint160).max));
        claimFunds(campaignId);
    }

    function test_RevertIf_NotEnded() public {
        deal(owner, goal);
        contribute(campaignId, goal);
        vm.expectRevert(DecentralizedCrowdfunding.CampaignNotEnded.selector);
        claimFunds(campaignId);
    }

    function test_RevertIf_GoalNotReached() public {
        vm.warp(deadline);
        vm.expectRevert(DecentralizedCrowdfunding.GoalNotReached.selector);
        claimFunds(campaignId);
    }

    function test_RevertIf_AlreadyClaimed() public {
        deal(owner, goal);
        contribute(campaignId, goal);
        vm.warp(deadline);
        claimFunds(campaignId);
        vm.expectRevert(DecentralizedCrowdfunding.FundsAlreadyClaimed.selector);
        claimFunds(campaignId);
    }
}

contract WithdrawContributionTest is DecentralizedCrowdfundingBaseTest {
    /*
    withdrawContribution:

    Withdraw contribution from existing campaign which address is owner, campaign not reached the goal and campaign ended.
    Withdraw contribution from non existing campaign.
    Withdraw contribution from existing campaign which not ended.
    Withdraw contribution from existing campaign which funding goal reached.
    Withdraw contribution from existing campaign which ended, not reached the goal and address not contributed.
    */
    event FundsClaimed(uint256 indexed campaignId, uint256 amount);

    function setUp() public override {
        super.setUp();
        createCampaign(goal, duration);
    }

    function test_GetRefund() public {
        deal(contributor, contributeAmount);
        vm.startPrank(contributor);
        contribute(campaignId, contributeAmount);
        uint256 startBalance = contributor.balance;

        vm.warp(deadline);
        withdrawContribution(campaignId);

        uint256 endBalance = contributor.balance;

        assertEq(startBalance, 0);
        assertEq(endBalance, contributeAmount);
    }

    function test_RevertIf_CampaignNotExists() public {
        vm.expectRevert("Campaign not exists");
        withdrawContribution(type(uint256).max);
    }

    function test_RevertIf_NotEnded() public {
        vm.expectRevert(DecentralizedCrowdfunding.CampaignNotEnded.selector);
        withdrawContribution(campaignId);
    }

    function test_RevertIf_GoalReached() public {
        hoax(contributor, goal);
        contribute(campaignId, goal);
        vm.warp(deadline);

        vm.expectRevert(DecentralizedCrowdfunding.GoalReached.selector);
        withdrawContribution(campaignId);
    }

    function test_RevertIf_NotContributed() public {
        vm.warp(deadline);

        vm.expectRevert(DecentralizedCrowdfunding.NoContributionMade.selector);
        vm.prank(contributor);
        withdrawContribution(campaignId);
    }
}
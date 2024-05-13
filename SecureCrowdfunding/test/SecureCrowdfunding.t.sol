// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {SecureCrowdfunding} from "../src/SecureCrowdfunding.sol";

contract SecureCrowdfundingTest is Test {
    SecureCrowdfunding public crowdFund;
    uint256 campaignId = 1;
    address owner = address(this);
    uint256 goal = 3 ether;
    uint256 duration = 5 days;
    uint256 deadline = block.timestamp + duration;
    address contributor = address(1);
    uint256 contributeAmount = 1 ether;

    function setUp() public virtual {
        crowdFund = new SecureCrowdfunding();
    }

    function createCampaign(uint256 _goal, uint256 _duration) internal {
        crowdFund.createCampaign(_goal, _duration);
    }

    function contribute(uint256 _campaignId, uint256 _amount) internal {
        crowdFund.contribute{value: _amount}(_campaignId);
    }

    function claimFunds(uint256 _campaignId) internal {
        crowdFund.claimFunds(_campaignId);
    }

    function refundCampaign(uint256 _campaignId) internal {
        crowdFund.refundCampaign(_campaignId);
    }
}

contract createCampaignTest is SecureCrowdfundingTest {
    event CampaignCreated(uint256 indexed campaignId, address owner, uint256 goal, uint256 deadline);

    function setUp() public override {
        super.setUp();
    }

    function test_createCampaign() public {
        vm.expectEmit(true, true, true, true);
        emit CampaignCreated(campaignId, owner, goal, deadline);

        createCampaign(goal, duration);
        (address _owner, uint256 _goal, uint256 _deadline, uint256 _fundsRaised, bool _claimed) =
            crowdFund.campaigns(campaignId);
        assertEq(_goal, goal);
        assertEq(_deadline, deadline);
        assertEq(_owner, owner);
        assertFalse(_claimed);
        assertEq(_fundsRaised, 0);
    }

    function test_invalidGoal() public {
        vm.expectRevert(SecureCrowdfunding.InvalidGoal.selector);
        createCampaign(0, duration);
    }
}

contract contributeCompaignTest is SecureCrowdfundingTest {
    event ContributionMade(uint256 indexed campaignId, address contributor, uint256 amount);

    function setUp() public override {
        super.setUp();
        createCampaign(goal, duration);
    }

    function test_contribute() public {
        vm.expectEmit(true, true, true, true);
        hoax(contributor, contributeAmount);
        emit ContributionMade(campaignId, contributor, contributeAmount);

        contribute(campaignId, contributeAmount);
        (address _owner, uint256 _goal, uint256 _deadline, uint256 _fundsRaised, bool _claimed) =
            crowdFund.campaigns(campaignId);
        
        assertEq(_goal, goal);
        assertEq(_deadline, deadline);
        assertEq(_owner, owner);
        assertFalse(_claimed);
        assertEq(_fundsRaised, contributeAmount);
    }

    function test_contributeCampaignEnded() public {
        hoax(contributor, contributeAmount);
        vm.warp(deadline);
        vm.expectRevert(SecureCrowdfunding.CampaignEnded.selector);
        contribute(campaignId, contributeAmount);
    }

    function test_contributeInvalidContribution() public {
        hoax(contributor, contributeAmount);
        vm.expectRevert(SecureCrowdfunding.InvalidContribution.selector);
        contribute(campaignId, 0);
    }

    function test_compaignDoesNotExist() public {
        hoax(contributor, contributeAmount);
        vm.expectRevert(SecureCrowdfunding.InvalidCampaignId.selector);
        contribute(type(uint256).max, contributeAmount);
    }
}

contract claimFundsTest is secureCrowdFundingTest {
    event FundsClaimed(uint256 indexed campaignId, uint256 amount);

    function setUp() public {
        super.setUp();
        createCampaign(goal, duration);
        hoax(contributor, contributeAmount);
        contribute(campaignId, contributeAmount);
    }

    function test_claimFunds() public {
        
    }

    function test_CampaignNotEnded() public {

    }

    function InvalidCampaignId() public {

    }

    function test_GoalNotReached() public {

    }

    function FundsAlreadyClaimed() public {

    }
}

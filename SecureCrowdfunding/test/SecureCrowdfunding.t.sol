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

contract createCampaign is SecureCrowdfundingTest {
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

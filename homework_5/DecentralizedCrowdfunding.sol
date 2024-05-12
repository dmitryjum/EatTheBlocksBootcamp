// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

/* 
Task:
1. Find and fix vulnerabilities.
2. Optionally - Prove with tests that contract is safe.
*/

contract DecentralizedCrowdfunding is Ownable, ReentrancyGuard {
    struct Campaign {
        address payable owner;
        uint256 goal;
        uint256 deadline;
        uint256 fundsRaised;
        bool claimed;
        address[] contributors;
        mapping(address => uint256) contributions;
    }

    uint256 public numCampaigns;
    mapping(uint256 => Campaign) public campaigns;

    event CampaignCreated(uint256 indexed campaignId, address owner, uint256 goal, uint256 deadline);
    event ContributionMade(uint256 indexed campaignId, address contributor, uint256 amount);
    event FundsClaimed(uint256 indexed campaignId, uint256 amount);

    error InvalidGoal();
    error CampaignEnded();
    error InvalidContribution();
    error NoContributionMade();
    error CampaignNotEnded();
    error GoalReached();
    error GoalNotReached();
    error FundsAlreadyClaimed();

    function createCampaign(uint256 _goal, uint256 _duration) external {
        if (_goal == 0) revert InvalidGoal();
        uint256 deadline = block.timestamp + _duration;
        Campaign storage newCampaign = campaigns[numCampaigns++];
        newCampaign.owner = payable(msg.sender);
        newCampaign.goal = _goal;
        newCampaign.deadline = deadline;
        newCampaign.fundsRaised = 0;
        newCampaign.claimed = false;
        emit CampaignCreated(numCampaigns, msg.sender, _goal, deadline);
    }

    function contribute(uint256 _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp >= campaign.deadline) revert CampaignEnded();
        if (msg.value == 0) revert InvalidContribution();
        
        campaign.fundsRaised += msg.value;
        uint256 currentContribution = campaign.contributions[msg.sender];
        if (currentContribution == 0) {
          campaign.contributors.push(msg.sender);
        }
        currentContribution += msg.value;
        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function claimFunds(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId]; // memory will be temporary and claimed = true will never save
        require(campaign.owner == != address(0), "this campaign does not exist");
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised < campaign.goal) revert GoalNotReached();
        if (campaign.claimed) revert FundsAlreadyClaimed();
        require(campaign.owner = msg.sender, "only owner");
        campaign.claimed = true;
        campaign.owner.call{value: campaign.fundsRaised}("");
        emit FundsClaimed(_campaignId, campaign.fundsRaised);
    }

    function refundCampaign(uint256 _campaignId) external nonReentrant {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.owner == != address(0), "this campaign does not exist");
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised >= campaign.goal) revert GoalReached();
        uint contribution = campaign.contributions[msg.sender];
        require(contribution > 0, "no contribution made");
        campaign.contributions[msg.sender] = 0;
        (bool sent, ) = payable(contributorAddress).call{value: contribution}("");
        require(sent == true, "transfer failed");
    }
}
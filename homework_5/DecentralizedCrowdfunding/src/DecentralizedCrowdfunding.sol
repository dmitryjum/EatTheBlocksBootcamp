/* 
  Part 1
  
- Solidity version vulnerable for overflow/underflow
- No checking if campaign exists
- DoS posibility in refundAll(), changed to withdrawContribution() (pull over push pattern)
- using .transfer instead of call in claim funds
- ClaimFunds used memory instead of storage
- ClaimFunds not checking for msg.sender == campaign.owner
- ClaimFunds not using check-effect-interaction pattern
  
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract DecentralizedCrowdfunding {
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
    error NotOwnerOfCampaign();
    error NoContributionMade();
    error CampaignNotEnded();
    error GoalReached();
    error GoalNotReached();
    error FundsAlreadyClaimed();
    error TransferFailed();

    modifier onlyExistingCampaign(uint256 _campaignId) {
        require(numCampaigns >= _campaignId, "Campaign does not exist");
        _;
    }

    function createCampaign(uint256 _goal, uint256 _duration) public {
        if (_goal == 0) revert InvalidGoal();
        uint256 deadline = block.timestamp + _duration;
        Campaign storage newCampaign = campaigns[++numCampaigns];
        newCampaign.owner = payable(msg.sender);
        newCampaign.goal = _goal;
        newCampaign.deadline = deadline;
        newCampaign.fundsRaised = 0;
        newCampaign.claimed = false;
        emit CampaignCreated(numCampaigns, msg.sender, _goal, deadline);
    }

    function contribute(uint256 _campaignId) external payable onlyExistingCampaign(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp >= campaign.deadline) revert CampaignEnded();
        if (msg.value == 0) revert InvalidContribution();
        
        if(campaign.contributions[msg.sender] == 0) {
            campaign.contributors.push(msg.sender);
        }

        campaign.fundsRaised += msg.value;
        campaign.contributions[msg.sender] += msg.value;
        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function claimFunds(uint256 _campaignId) external onlyExistingCampaign(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        if (msg.sender != campaign.owner) revert NotOwnerOfCampaign();
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised < campaign.goal) revert GoalNotReached();
        if (campaign.claimed) revert FundsAlreadyClaimed();
        
        campaign.claimed = true;
        (bool sent, ) = campaign.owner.call{ value: campaign.fundsRaised }("");
        if(!sent) revert TransferFailed();
            
        emit FundsClaimed(_campaignId, campaign.fundsRaised);
    }

    function withdrawContribution(uint256 _campaignId) external onlyExistingCampaign(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        if (block.timestamp < campaign.deadline) revert CampaignNotEnded();
        if (campaign.fundsRaised >= campaign.goal) revert GoalReached();
        uint256 contribution = campaign.contributions[msg.sender];
        if (contribution == 0) revert NoContributionMade();

        campaign.contributions[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{ value: contribution }("");
        if(!sent) revert TransferFailed();
    }
}
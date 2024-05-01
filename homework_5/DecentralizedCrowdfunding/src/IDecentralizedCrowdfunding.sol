// src/IDecentralizedCrowdfunding.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

interface IDecentralizedCrowdfunding {
    function createCampaign(uint256 _goal, uint256 _duration) external;
    function contribute(uint256 _campaignId) external payable;
    function withdrawContribution(uint256 _campaignId) external;
    function numCampaigns() external view returns (uint256);
}
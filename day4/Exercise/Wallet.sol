pragma solidity 0.8.25;

import {ICharity} from "./ICharity.sol";

contract Wallet {
    address public owner;
    ICharity public charity;

    error CanNotDepositZeroEthers();
    error NotOwner();
    error NotEnoughMoney();
    error TransferFailed(); // custom errors cost less gas

    uint256 charityPercentage = 50;

    constructor(address _charityAddress) {
        owner = msg.sender;
        charity = ICharity(_charityAddress);
    }

    function deposit() external payable {
        if(msg.value == 0) {
            revert CanNotDepositZeroEthers();
        }

        uint256 charityAmount = (msg.value * charityPercentage) / 1000;

        charity.donate{value: charityAmount}();
    }

    function withdraw(uint256 amount) external {
        if(msg.sender != owner) {
            revert NotOwner();
        }

        uint256 currentBalance = address(this).balance;
        if(amount > currentBalance) {
            revert NotEnoughMoney();
        }

        (bool success, ) = payable(owner).call{value: amount}("");

        if(!success) {
            revert TransferFailed();
        }
    }
}
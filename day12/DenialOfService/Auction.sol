// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Auction is Ownable, ReentrancyGuard {
    using Address for address payable;

    struct Refund {
        address payable addr;
        uint256 amount;
    }

    Refund[] public refunds;
    address public highestBidder;
    uint256 public highestBid;

    constructor() Ownable(msg.sender) {}

    function bid() external payable {
        require(msg.value > highestBid, "not bigger bid amount");

        if (highestBidder != address(0)) {
            refunds.push(Refund(payable(highestBidder), highestBid));
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function refundAll() external onlyOwner nonReentrant {
        for (uint256 i = 0; i < refunds.length; i++) {
            refunds[i].addr.sendValue(refunds[i].amount);
        }
        delete refunds;
    }
}
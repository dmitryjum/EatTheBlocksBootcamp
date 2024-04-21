// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {TransferContract} from "../../src/2.Transfers/TransferContract.sol";

contract TransferContractTest is Test {
    TransferContract public transferContract;

    address myAddress = address(1);

    function setUp() public {
        transferContract = new TransferContract();
    }

    function test_Airdrop() public {
        uint256 startBalance = myAddress.balance;
        console.log("Start balance: ", startBalance);
        uint256 newBalance = 10 ether;

        deal(myAddress, newBalance);

        uint256 currentBalance = myAddress.balance;
        console.log("Current balance: ", currentBalance);

        assertEq(currentBalance, newBalance);
    }

    function test_SendEthers() public {
        uint256 startBalance = address(transferContract).balance;
        uint256 newBalance = 10 ether;

        hoax(myAddress, newBalance);

        (bool success, ) = payable(address(transferContract)).call{value: newBalance}("");
        assertTrue(success);

        uint256 currentBalance = address(transferContract).balance;

        assertEq(currentBalance, newBalance);
    }
}
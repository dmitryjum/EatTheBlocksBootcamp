// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../../src/Wallet.sol";
import {WalletBaseTest} from "./WalletBase.t.sol";

contract WalletInitialStateTest is WalletBaseTest {
    function test_InitialState() public view {
        assertEq(wallet.owner(), owner);
        assertEq(address(wallet.charity()), address(charity));
    }
}

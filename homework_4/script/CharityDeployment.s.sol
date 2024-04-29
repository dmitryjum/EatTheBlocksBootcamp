// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Charity} from "../src/Charity.sol";
import {Wallet} from "../src/Wallet.sol";
import {Script, console} from "forge-std/Script.sol";

contract CharityDeploymentScript is Script {
  Charity public charity;
  Wallet public wallet;

  uint256 charityPercentage = 50;
  uint256 moneyCollectingDeadline = 365 days;

  function run() public {
    vm.createSelectFork(vm.rpcUrl("local")); //networks are specified in foundry.toml and local private key should be used
    // vm.createSelectFork(vm.rpcUrl("sepolia")); // ether the personal private key or vanity wallet should be used and should have the sepolia funds on it
    uint privateKey = vm.envUint("PRIVATE_KEY");
    address owner = vm.addr(privateKey);
    vm.startBroadcast(privateKey);

    charity = new Charity(owner, moneyCollectingDeadline);
    wallet = new Wallet(owner, address(charity), charityPercentage);
    wallet.deposit{value: 0.001 ether}();

    vm.stopBroadcast();
  }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counter} from "../src/Counter.sol";
import {Script, console} from "forge-std/Script.sol";

contract CounterScript is Script {
    Counter public counter;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("sepolia")); // sepolia is the testnet
        uint privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey); // sends one transaction ot the blockchain
        counter = new Counter();
        counter.setNumber(17042024);
        counter.increment();
        vm.stopBroadcast(); // to prevent broadcasting other transactions
    }
}

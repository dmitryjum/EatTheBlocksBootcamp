pragma solidity 0.8.25;

import {IMyStorage} from "./IMyStorage.sol";

contract DataChanger {

    IMyStorage public myStorage;
    // address public myStorageAddress;

    constructor(address _myStorageAddress) {
        // myStorageAddress = _myStorageAddress;
        myStorage = IMyStorage(_myStorageAddress);
    }

    function changeData(uint256 someNewData) external {
        // (bool success, ) = myStorageAddress.call(abi.encodeWithSignature("changeData(uint256", someNewData)); // to communicate with another contract
        // require(success);

        myStorage.changeData(someNewData);
    }

    function makeDeposit() external payable {
        // (bool success, ) = payable(myStorageAddress).call{value: msg.value(abi.encodeWithSignature("deposit()")); // to communicate with another contract
        // require(success);

        myStorage.deposit{value: msg.value}();
    }

    function test() external {
        for(uint256 i = 0; i < 10; i++) {

        }

        //while and do work the same way as in C and JS (do {} while(condition))
    }

}
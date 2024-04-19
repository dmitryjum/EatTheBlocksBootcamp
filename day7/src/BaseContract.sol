// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract BaseContract {
    uint256 public number;
    uint256[] public array;
    mapping(uint => uint) public simpleMapping;
    mapping(uint => mapping(uint => uint)) public nestedMapping;

    constructor() {
        simpleMapping[0] = 1;
        nestedMapping[0][0] = 1;
        array.push(1);
    }

    function increment() external {
        number++;
    }
}
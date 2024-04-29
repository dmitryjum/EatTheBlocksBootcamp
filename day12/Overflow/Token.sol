// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

contract Token {
    mapping(address => uint256) public balances;

    constructor() {
        balances[msg.sender] = 10000;
    }

    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] - amount > 0, "not enough balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/Address.sol";

contract Wallet {
    using Address for address payable;

    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0);
        
        balances[msg.sender] = 0;

        payable(msg.sender).sendValue(amount);
    }
}
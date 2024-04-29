// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/Address.sol";

contract Wallet {
    using Address for address payable;

    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    // Vulnurable function
    function withdraw() external {
        require(balances[msg.sender] > 0);
        payable(msg.sender).sendValue(balances[msg.sender]);
        balances[msg.sender] = 0;
    }

    // better protected function
    function withdraw() external nonReentrant {
        uint256 amount = balance[msg.sender];
        require(amount > 0);
        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
    }

    bool entered;

    modifier nonReentrant() {
      require(!entered);
      entered = true;
      _;
      entered = false;
    }
}
//ICO

//Example

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(
        string memory name, 
        string memory ticker, 
        uint256 initialSupply
    ) ERC20(name, ticker) {
        _mint(msg.sender, initialSupply);
    }
}

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ICO {
    IERC20 public token;
    uint256 public totalTokens;
    uint256 public deadline;
    uint256 public minInvestment;
    bool public started;
    address payable public admin;

    mapping(address => uint256) public investments;

    event Invest(address indexed investor, uint256 amount);
    event Withdraw(address indexed investor, uint256 amount);

    constructor(IERC20 _token, uint256 _totalTokens, uint256 _deadline, uint256 _minInvestment) {
        token = _token;
        totalTokens = _totalTokens;
        deadline = _deadline;
        minInvestment = _minInvestment;
    }

    function start() external {
        require(msg.sender == admin, "only admin");
        token.transferFrom(address(msg.sender), address(this), totalTokens);
        started = true;
    }

    function invest() external payable {
        require(started == true, "ICO hasn't started");
        require(block.timestamp < deadline, "ICO has ended");
        require(msg.value >= minInvestment, "Investment amount too low");
        investments[msg.sender] += msg.value;
        emit Invest(msg.sender, msg.value);
    }

    function withdrawToken() external {
        require(block.timestamp >= deadline, "ICO has not ended yet");
        require(investments[msg.sender] > 0, "No investment to withdraw");

        uint256 amount = investments[msg.sender];
        investments[msg.sender] = 0;
        uint tokensToReceive = amount * totalTokens / address(this).balance;
        require(tokensToReceive > 0, "No tokens to receive");
        token.transfer(msg.sender, tokensToReceive);
        emit Withdraw(msg.sender, amount);
    }

    function withdrawETH() external {
        require(block.timestamp >= deadline + 7 days, "Too soon to withdraw ETH");
        require(msg.sender == admin, "only admin");
        admin.call{value: address(this).balance}("");
    }
}
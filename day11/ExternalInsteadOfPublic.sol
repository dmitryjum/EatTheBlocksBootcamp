//Gas optimization technique #11: Use external instead of public
pragma solidity 0.8.24;

//problem
contract MyContract {
  function foo() public {}
}

//solution
contract MyContract {
  function foo() external{}
}
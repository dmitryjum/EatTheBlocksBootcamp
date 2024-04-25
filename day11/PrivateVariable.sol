//Gas optimization technique #10: Use private variables

pragma solidity 0.8.24;

//problem
contract MyContract {
  uint public data;
}

//solution
contract MyContract {
  uint private data;
}
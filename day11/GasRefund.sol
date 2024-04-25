//Gas optimization technique #12: Use gas refunds

pragma solidity 0.8.24;

contract MyContract {
   uint public data;

   function set(uint _data) external {
        data = _data;
   }

    function reset() external {
        delete data;
    }
}
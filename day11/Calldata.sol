//Gas optimization technique #8: Calldata
pragma solidity 0.8.24;

contract MyContract {
    function foo(address[] memory recipients) external {
        //do something with recipients
    }
}

contract MyContractOptimized {
    function foo(address[] calldata recipients) external {
        //do something with recipients
    }
}
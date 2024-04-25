//Gas optimization technique #5: Constant / immutable keyword
pragma solidity 0.8.24;

contract MyContract {
    uint public data = 10; //never changes
}

//Better to do this
contract MyContractOptimized {
    uint constant public data = 10;
}

//Alternative if it needs to be initialized dynamically
contract MyContractOptimized2 {
    uint immutable public data;
    constructor(uint _data) {
        data = _data; 
    }
}
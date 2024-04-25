//Gas optimization technique #3: Variable packing

pragma solidity 0.8.24;

//problem
contract MyContract {
    uint8 a;
    bool isLocked;
    uint248 b;
    uint128 c;
    uint totalSupply;
    uint64 d;
    address owner;
    uint64 e;
}

//solution
contract MyContract {
    address owner;
    bool isLocked;
    uint totalSupply;
    uint248 b;
    uint8 a;
    uint128 c;
    uint64 d;
    uint64 e;
}
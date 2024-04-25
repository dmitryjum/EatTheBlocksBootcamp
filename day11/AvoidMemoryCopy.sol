//Gas optimization technique #9: Avoid useless memory copies
pragma solidity 0.8.24;

contract MyContract {
    struct User {
        address owner;
        uint balance;
    }
    mapping(address => User) public users;

    function foo(address addr) external {
        User memory user = users[addr];
        //Read value from user
    }
}

contract MyContractOptimized {
    struct User {
        address owner;
        uint balance;
    }
    mapping(address => User) public users;
    function foo(address addr) external {
        User storage user = users[addr];
        //Read value from user
    }
}
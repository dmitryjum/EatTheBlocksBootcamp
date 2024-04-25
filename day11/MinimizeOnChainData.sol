//Gas optimization technique #1: Minimize on-chain data

//Problem
pragma solidity 0.8.24;

contract MyContract {
    struct User {
        uint id;
        string name;
        bytes images;
        uint balance;
    }
    mapping(uint => User) public users;
    uint public nextId;

    function createUser(string calldata name, bytes calldata image) external {
        users[nextId] = User(nextId, name, image, 0);
        nextId++;
    }
}

//solution
pragma solidity 0.8.24;

contract MyContract {
    struct User {
        string url;
        bytes32 hash;
        uint balance;
    }
    mapping(uint => User) public users;
    uint public nextId;

    function createUser(string calldata url, bytes32 hash) external {
        users[nextId] = User(url, hash, 0);
        nextId++;
    }
}
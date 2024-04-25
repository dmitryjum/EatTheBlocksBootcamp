//Gas optimization technique #7: Use mappings instead of arrays
pragma solidity 0.8.24;

contract MyContract {
    struct User {
        address owner;
        uint balance;
    }
    User[] public users;

    function addUser(address owner) external {
        users.push(User(owner, 0));
    }
}

contract MyContractOptimized {
    mapping(address => uint) public balances;
    function foo(address owner) external {
        balances[owner] = 0;
    }
}
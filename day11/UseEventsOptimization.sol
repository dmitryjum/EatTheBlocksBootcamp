//Gas optimization technique #4: use events
pragma solidity 0.8.24;

//problem
contract MyToken {
    struct Transfer {
        address from;
        address to;
        uint amount;
        uint date;
    }
    mapping(uint => Transfer) public transfers;
    uint public nextId;
    mapping(address => uint) public balances;

    function transfer(address to, uint amount) external {
        require(balances[msg.sender] >= amount, "balance too low");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        transfers[nextId] = Transfer(msg.sender, to, amount, block.timestamp);
        nextId++;
    }
}

//solution
pragma solidity 0.8.24;

contract MyToken {
    event Transfer (
        address from,
        address to,
        uint amount
    );
    mapping(address => uint) public balances;

    function transfer(address to, uint amount) external {
        require(balances[msg.sender] >= amount, "balance too low");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}

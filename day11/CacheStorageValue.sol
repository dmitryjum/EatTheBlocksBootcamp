//Gas optimization technique #6: Cache storage value
pragma solidity 0.8.24;

contract MyContract {
   mapping(address => uint) public balances;

    function foo(address owner) external {
        require(balances[owner] > 1 ether, "balance too low");
        if(balances[owner] > 2 ether) {
            balances[owner] += 1 ether;
        }
    }
}

contract MyContractOptimized {
    mapping(address => uint) public balances;
    function foo(address owner) external {
        uint balance = balances[owner];
        require(balance > 1 ether, "balance too low");
        if(balance > 2 ether) {
            balances[owner] += 1 ether;
        }
    }
}
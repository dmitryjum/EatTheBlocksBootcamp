//Gas optimization technique #2: Solidity optimizer

//Without Solidity optimizer (200 passes) foo() uses 43696 gas
//With optimizer, foo() uses only 43491 gas
contract MyContract {
    uint public data;
    function foo(uint _data) external {
        data = _data;
    }
}
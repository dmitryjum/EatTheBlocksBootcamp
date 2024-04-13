pragma solidity 0.8.25;

contract Simple {
    uint public data;
    constructor(uint _data) {
        data = _data;
    }
}

contract AccessControl {
    address public ownner = 0x6093;
    function foo() external {
        require(msg.sender == owner, "not owner")
    }
}
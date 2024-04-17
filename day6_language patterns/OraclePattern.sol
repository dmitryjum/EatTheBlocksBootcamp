//Oracle pattern
contract OraclePattern {
    address public owner;
    uint public maxDelay;
    bytes32 public data;

    constructor(address _owner, uint _maxDelay) {
        owner = _owner;
        maxDelay = _maxDelay;
    }

    function updateData(bytes32 _data, uint date) external {
        require(msg.sender == owner, "Owner only");
        require(date >= block.timestamp - maxDelay, "Stale data");
        data = _data;
    }
}
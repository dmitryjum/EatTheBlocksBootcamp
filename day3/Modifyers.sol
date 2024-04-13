pargma solidity 0.8.25;

contract ModifyerContract {
    address public owner;
    uint256 public veryCrucialData;

    mapping(address => bool) public approved;

    constructor() {
        owner = msg.sender;
        approved[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyApproved() {
        require(approved[msg.sender], "Only approved can call this function");
    }

    function setApproval(address user, bool isApproved) external onlyOwner {
        approved[msg.sender] = isApproved;
    }

    function setVeryCrucialData(uint256 newData) external onlyApproved {
        veryCrucialData = new Data;
    }
}
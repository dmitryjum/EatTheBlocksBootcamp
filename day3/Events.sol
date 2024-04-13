pragma solidity 0.8.25;

contract EventsContract {
    event Deposited(address indexed user, uint256 value); // only 3 indexed parameters
    event Withdrawn(address indexed user, uint256 value);

    mapping(address => uint256) public userBalance;

    function deposit() external payable {
        userBalance[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external {
        // some code

        emit Withdrawn(msg.sender, amount);
    }
}
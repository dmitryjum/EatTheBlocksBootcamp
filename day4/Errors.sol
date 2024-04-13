pragma solidity 0.8.25;

contract Errors {

    error NotEnoughMoney(uint256 owned, uint256 amount);
    error TransferFailed();

    mapping(address => uint256) public userBalances;

    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        uint256 owned = userBalances[msg.sender];
        if (amount > owned) {
            revert NotEnoughMoney(owned, amount);
        }

        userBalances[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if (!success) {
            revert TransferFailed();
        }
    }
}
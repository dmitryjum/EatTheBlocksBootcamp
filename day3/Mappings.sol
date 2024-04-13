pragma solidity 0.8.25;

contract PublicWallet {
    mapping(address => uint256) public userBalances; // public automatically creates a getter function in Solidity

    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = userBalances[msg.sender];
        require(amount > 0, "you have no funcds");
        userBalances[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        
        require (success, "transfer failed");
    }
}
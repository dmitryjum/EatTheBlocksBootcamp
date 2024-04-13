pargma solidity 0.8.25;

contract Charity {
    event Donated(address indexed donator, uint256 amount);
    error NotEnoughDonationAmount();
    mapping(address => uint256) public userDonations;

    function donate() external payable {
        if(msg.value == 0) {
            revert NotEnoughDonationAmount();
        }

        userDonations[msg.sender] += msg.value;

        emit Donated(msg.sender, msg.value);
    }
}

  // Exercise
    // Create contract Charity which
    // have a mapping for storing how much Ethers each address have sent
    // have event Donated with two params, address indexed donator and uint256 amount
    // have a function donate which will accept Ether transfers (should be payable)
    // require that msg.value > 0 (use custom errors later)
    // update userDonations mapping
    // emit event Donated
    // Create interface ICharity for Charity
    // needs to have a donate function signature
    // Create contract Wallet which
    // have owner variable
    // have charity variable ICharity
    // have variable for percentage which will go to Charity
    // constructor, where you provide Charity address and save it in charity variable and owner of wallet
    // have a function deposit which will accept Ethers and send 5% to Charity contract
    // hint: to calculate percentage, let’s keep percentageRate = 50, then amount to charity can be calculated by (msg.value * charityPercentage) / 1000;
    // have a function withdraw which will withdraw specified amount by user
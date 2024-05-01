pragma solidity 0.8.23;

contract BatchProcessor {
    mapping(address => uint) private balances;

    event Distribution (
      address recipient,
      uint amount
    )

    error RecipientsAndAmountsNotEqualError();
    error BalanceTooLowError();

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function batchProcess(address[] calldata recipients, uint[] calldata amounts) external {
        uint recipientsLength = recipients.length;
        if (recipientsLength != amounts.length) {
            revert RecipientsAndAmountsNotEqualError();
        }
        uint currentBalance = balances[msg.sender];
        for (uint i = 0; i < recipientsLength; i++) {
            uint amount = amounts[i]
            if (currentBalance < amounts[i]) {
                revert BalanceTooLowError();
            }
            currentBalance -= amount;
            balances[recipients[i]] += amount;
            emit Distribution(recipient[i], amount)
        }
    }
}

contract UnoptimizedBatchProcessor {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public distributed;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function batchProcess(address[] memory recipients, uint[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must be of equal length");

        for (uint i = 0; i < recipients.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance");
            balances[msg.sender] -= amounts[i];
            balances[recipients[i]] += amounts[i];
            distributed[msg.sender][recipients[i]] = amounts[i];
        }
    }
}
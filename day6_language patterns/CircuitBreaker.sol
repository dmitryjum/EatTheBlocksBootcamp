//Circuit breaker

//explanation
contract CircuitBreaker {
    bool public stopped;
    address public owner;

    constructor() {
        owner = msg.sender; // Set the owner to the account that deploys the contract
    }

    // Modifier to check if the circuit breaker is active
    modifier stopInEmergency() {
        require(!stopped, "Contract is stopped in emergency");
        _;
    }

    // Function to enable the circuit breaker
    function toggleCircuitBreaker() external {
        require(msg.sender == owner, "Not authorized");
        stopped = !stopped;
    }

    // Example function that can be halted using the circuit breaker
    function transferFunds(address to, uint amount) external stopInEmergency() {
        // Code to transfer funds
    }
}

//Exercise solution
contract CircuitBreaker {
    bool public stopped;
    address public owner;

    constructor() {
        owner = msg.sender; // Set the owner to the account that deploys the contract
    }

    // Modifier to check if the circuit breaker is active
    modifier stopInEmergency() {
        require(!stopped, "Contract is stopped in emergency");
        _;
    }

    // Function to enable the circuit breaker
    function toggleCircuitBreaker() external {
        require(msg.sender == owner, "Not authorized");
        stopped = !stopped;
    }

    //circuit breaker
        function deposit() external payable stopInEmergency() {
    }
    
    //circuit breaker
        function withdraw() external payable stopInEmergency() {
    }
    
    function getBalance(address owner) external view returns(uint) {
    }
}

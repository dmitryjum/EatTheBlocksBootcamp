//Access control

//Explanation
contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender; // Set the owner to the account that deploys the contract
    }

    // Modifier to check if this is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Function to enable the circuit breaker
    function foo() external onlyOwner() {
        //Do something
    }
}

//Exercise solution
contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender; // Set the owner to the account that deploys the contract
    }

    // Modifier to check if this is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function foo() external {
        //Do something
    }

    //owner only
    function bar() external {
        //Do something
    }

    //owner only
    function baz() external {
        //Do something
    }
}

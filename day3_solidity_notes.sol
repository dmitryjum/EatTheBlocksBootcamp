pragma solidity 0.8.0;

contract Wallet {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function deposit() external payable {

    }

    function send(address payable to) external payable {
        to.call{value: msg.value}("");
    }
}

pragma solidity 0.8.0;

contract Wallet {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function deposit() external payable {

    }

    function send(address payable to, uint256 amount) external payable {
        to.call{value: amount}("");
    }

    function withdraw(address payable to, uint256 amount) external payable {
        require(msg.sender == owner, "", "you're not the owner");
        to.call{value: amount}("");
    }

}

contract Wallet {
     address public owner;
    constructor(address _owner) {
         owner = _owner;
    }
    function deposit() external payable {}
    
    function withdraw(address payable to, uint amount) external{
        require(msg.sender == owner, "only owner");
        to.call{value: amount}("");
    }
}


// someone's code:
pragma solidity ^0.8.0;
contract LockedWallet {
    address public beneficiary;
    uint256 public unlockTime;
    
    constructor(address _beneficiary, uint256 _unlockTime) payable {
        owner = msg.sender;
        unlockTime = block.timestamp + _unlockTime;
    }
    
    function deposit() external payable {}
    
    function withdraw(address payable to, uint256 amount) external {
        require(msg.sender == beneficiary, "Only owner can withdraw");
        require(block.timestamp >= unlockTime, "Funds are still locked");
        
        (bool success, ) = payable(beneficiary).call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }


// Arrays can only contain a single type in Solidity
// Fixed-Size Array - its size can't be changed

pragma solidity 0.8.25;

contract FixedSizeArrayContract {
    uint256[10] public numbers; // the variable will return only the value of the specific index
    
    constructor() {
        numbers[0] = 1; // other values will be 0, because that's the default
    }

    function setNumber(uint256 index, uint256 value) external {
        require(index < 10, "Invalid index");
        numbers[index] = value;
    }

    function getNumber(uint256 index) external view returns(uint256) {
        require(index < 10, "Invalid index");
        return numbers[index];
    } // view functions let us read the blockchain state

    function getWholeArray() external view returns(uint256[10] memory) {
        return numbers;
    }
        
}


contract RGBContract {

    uint8[3] private colors;

    constructor() {
        colors[0] = 255;
        colors[1] = 255;
        colors[2] = 255;
    }

    function setColor(uint colorId, uint8 value) external {
        require(colorId < 3, "Invalid color Id");
        colors[colorId] = value;

        uint256[] memory test = new uint256[](5); //fixed array can be instantiated inside a function, but the dynamic ones can't be created inside the function
    }

    function getColor(uint colorId) external view returns(uint8) {
        require(colorId < 3, "Invalid color Id");
        return colors[colorId];
    }

    function getRgb() external view returns(uint8[3] memory) {
        return colors;
    }
}

pragma solidity 0.8.25;

contract DynamicArrayContract {
    uint256[] private numbers;

    function addNumber(uint256 number) external {
        numbers.push(number);
    }

    function removeLastElement() external {
        numbers.pop();
    }

    function getArrayLength() external view returns(uint256) {
        return numbers.length;
    }

    function getValueAtIndex(uint256 index) external view returns(uint256) {
        return numbers[index];
    }
}


pragma solidity 0.8.25;

contract Mappings {
    mapping(uint256 => uint256) public testMapping; // public automatically creates a getter function in Solidity

    function setValue(uint256 key, uint256 value) external {
        testMapping[key] = value;
    }

    function getValue(uint256 key) external view returns(uint256) {
        return testMapping[key];
    }
}


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


emmitting events consumes less gas than storing values, but events are accessible only from outside a contract
A function can emmit event and a front end app can liston on those contract events (for example a transaction is coming)


pragma solidity 0.8.25;

contract EventsContract {
    event Deposited(address indexed user, uint256 value); // only 3 indexed parameters
    event Withdrawn(address indexed user, uint256 value);

    mapping(address => uint256) public userBalance

    function deposit() external payable {
        userBalance[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external {
        // some code

        emit Withdrawn(msg.sender, amount);
    }
}


Wagmi (React libarary for Ethereum)



pragma solidity 0.8.25;

contract BaseStore {
    uint256 private someValue;

    function setValue(uint256 newValue) public virtual {// if we want to overwrite this function in the deriviative contract
        someValue = newValue;
    }

    function getValue() public view returns(uint256) {
        return someValue;
    }
}

contract MyStore is BaseStore {
    uint256 public additionalValue;

    function setAdditionalValue(uint256 newValue) public {
        additionalValue = newValue;

        setValue(5);
    }

    function getCombinedValues() public  view returns(uint256){
        return someValue + additionalValue;
    }

    function setValue(uint256 newValue) public override {
        require(newValue > 5, "not the correct value");
        super.setValue(newValue); // call the base store contract logic eventhough it's overwriting it
    }
}

contract ModifiersExercise { address public owner; mapping(address => bool) public approved; uint256 veryCrucialData; constructor() { owner = msg.sender; approved[msg.sender] = true; } modifier onlyOwner() { require(owner == msg.sender, "User not owner"); _; } modifier onlyApproved() { require(approved[msg.sender], "User not approved"); _; } function setApproval(address user, bool isApproved) public onlyOwner { approved[user] = isApproved; } function setVeryCrucialData(uint256 data) public onlyApproved { // Code that can only be called by approved users veryCrucialData = data; } }

Exercise
Use previous contract (modifiers exercise)
Add 3 events
UserApproved(address indexed user)
UserDispproved(address indexed user)
VeryCrucialDataSet(address indexed user, uint256 newValue)
Modify setApproval function to emit event depending on isApproved value
Modify setVeryCrucialData to emit VeryCrucialDataSet event after setting data

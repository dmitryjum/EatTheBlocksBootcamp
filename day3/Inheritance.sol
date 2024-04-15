pragma solidity 0.8.25;

// contract BaseStore {
//     uint256 private someValue;

//     function setValue(uint256 newValue) public virtual {// if we want to overwrite this function in the deriviative contract
//         someValue = newValue;
//     }

//     function getValue() public view returns(uint256) {
//         return someValue;
//     }
// }

// contract MyStore is BaseStore {
//     uint256 public additionalValue;

//     function setAdditionalValue(uint256 newValue) public {
//         additionalValue = newValue;

//         setValue(5);
//     }

//     function getCombinedValues() public  view returns(uint256){
//         return someValue + additionalValue;
//     }

//     function setValue(uint256 newValue) public override {
//         require(newValue > 5, "not the correct value");
//         super.setValue(newValue); // call the base store contract logic eventhough it's overwriting it
//     }
// }

contract BaseStore {
    uint256 private someValue;

    function setValue(uint256 newValue) public virtual {
        someValue = newValue;
    }

    function getValue() public view returns(uint256) {
        return someValue;
    }
}

contract SecureStore is BaseStore {
    mapping(address => uint256) public authorizedAddresses;

    function authorizeUser(address user, bool isAuthorized) external {
        authorizedAddresses[user] = isAuthorized;
    }

    function setValue(uint256 newValue) public override {
        require(authorizedAddresses[msg.sender], "Only approved can call this function");
        super.setValue(newValue);
    }
}

contract ModifiersExercise {
    address public owner;
    mapping(address => bool) public approved;
    
    uint256 veryCrucialData;

     constructor() {
        owner = msg.sender;
        approved[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "User not owner");
        _;
    }

    modifier onlyApproved() {
        require(approved[msg.sender], "User not approved");
        _;
    }

    function setApproval(address user, bool isApproved) public onlyOwner {
        approved[user] = isApproved;
    }

    function setVeryCrucialData(uint256 data) public onlyApproved {
         // Code that can only be called by approved users veryCrucialData = data;
    }
}

Exercise
Use previous contract (modifiers exercise)
Add 3 events
UserApproved(address indexed user)
UserDispproved(address indexed user)
VeryCrucialDataSet(address indexed user, uint256 newValue)
Modify setApproval function to emit event depending on isApproved value
Modify setVeryCrucialData to emit VeryCrucialDataSet event after setting data
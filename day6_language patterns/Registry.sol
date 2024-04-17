//Registry pattern

pragma solidity ^0.8.4;

contract Registry {
    // Mapping of module names to their current addresses
    mapping(string => address) public modules;

    // Event that is emitted when a module is added or updated
    event ModuleUpdated(string moduleName, address moduleAddress);

    // Address of the contract owner
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict certain functionalities to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to add or update a module address
    function setModule(string calldata moduleName, address moduleAddress) public onlyOwner {
        require(moduleAddress != address(0), "Invalid module address");
        modules[moduleName] = moduleAddress;
        emit ModuleUpdated(moduleName, moduleAddress);
    }

    // Function to get the address of a module
    function getModule(string calldata moduleName) public view returns (address) {
        return modules[moduleName];
    }
}

contract RegistryUser {
    Registry public registry;
    constructor(address _registry) {
        registry = Registry(_registry);
    }

    function foo() external {
        address oracle = registry.getModule("oracle");
        //do something with oracle
    }
}
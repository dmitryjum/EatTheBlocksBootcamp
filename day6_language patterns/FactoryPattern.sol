//Factory pattern

//Lesson
pragma solidity 0.8.24;

contract ContractFactory {
    event NewChild(uint arg1, uint arg2);
    mapping(address => bool) public children;

    function createContract(uint arg1, uint arg2) external {
        Child child = new Child(arg1, arg2);
        children[address(child)] = true;
        emit NewChild(arg1, arg2);
    }
}

// Contract to be created by the factory
contract Child {
    constructor(uint arg1, uint arg2) {}
    // Contract implementation
}

//Exercise solution
pragma solidity 0.8.24;

contract ContractFactory {
    event NewChild(uint arg1, uint arg2);
    mapping(bytes32 => address) public children;

    function createContract(uint arg1, uint arg2) external {
        Child child = new Child(arg1, arg2);
      
        bytes32 hash;
        if(arg1 < arg2) {
            hash = keccak256(abi.encodePacked(arg1, arg2));
        } else {
            hash = keccak256(abi.encodePacked(arg2, arg1));
        }
        children[hash] = address(child);
        emit NewChild(arg1, arg2);
    }
}

// Contract to be created by the factory
contract Child {
    constructor(uint arg1, uint arg2) {}
    // Contract implementation
}
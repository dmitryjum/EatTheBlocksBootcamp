//Hash

//Lesson
pragma solidity 0.8.24;

contract Hash{
    function getHash(uint a, uint b) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(a, b));
    }
}

//Exercise solution
pragma solidity 0.8.24;

contract Hash{
    function getHash(address a, address b) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(a, b));
    }
}
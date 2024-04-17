//Simple update pattern

contract SimpleUpdate {
    address public owner;
    Implementation public implementation

    constructor(address _owner, address _implementation) {
        owner = _owner;
        implementation = Implementation(_implementation);
    }

    function updateImplementation(address _newImplementation) external {
        require(msg.sender == owner, "Only owner");
        implementation = Implementation(_newImplementation);
    }

    function foo() external payable {
        implementation.bar();
        //Do other things
    }
}

interface IImplementation{
    function bar() external payable;
}
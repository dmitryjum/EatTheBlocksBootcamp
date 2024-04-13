pragma solidity 0.8.25;

contract DataLocations {

    event MyStringChagned(string _newData);

    uint256 constant public CONSTANT_VALUE = 10;

    uint256 immutable public immutableValue1 = 10;
    uint256 immutable public immutableValue2 = 10;

    string public myText;

    struct TestStruct {
        string text;
    }

    mapping(uint256 => TestStruct) public structs;

    constructor() {
        immutableValue2 = 20;
    }

    function setStringFromCalldata(string calldata _newText) external {
        // _newText = "something"; can't be changed
        myText = _newText;
    }

    function setStringFromMemory(string memory _newText) external {
        _newText = "something";
        myText = _newText;
    }

    function setStringStorage() external {
        TestStruct storage data = structs[1]; // it'll stay in the contract data storage
        data.text = "some new text";

        emit MyStringChanged(data.text);
    }

    function setStringMemory() external {
        TestStruct memory data = structs[1]; // will be forgotten
        data.text = "some new text";
    }
}
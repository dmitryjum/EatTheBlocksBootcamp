pragma solidity 0.8.25;

contract ComplextStruct {
    struct MyStruct {
        uint256 myNumber;
        string myText;
        uint256[] myArray;
        mapping(uint256 => bool) myMapping;
    }

    MyStruct public myStruct;

    function initialize() public {
        myStruct.myNumber = 1;
        myStruct.myText = "some text";
        myStruct.myArray.push(10);
        myStruct.myArray.push(20);
        myStruct.myMapping[1] = true;
    }

    function getStructMappingValue(uint256 key) external view returns(bool) {
        return myStruct.myMapping[key];
    }
}
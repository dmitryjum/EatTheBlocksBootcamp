pragma solidity 0.8.25;

contract FixedSizeArrayContract {
    uint256[10] public numbers; // the variable will return only the value of the specific index
    
    constructor() {
        numbers[0] = 1;
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

contract RGB {
    uint8 private colors; // uint8 containst values from 0 to 255

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
        require(colorId < 3, "Invalid color id");
        return colors[colorId];
    }

    function getRgb() external view returns(uint8[3] memory) {
        return colors;
    }
}
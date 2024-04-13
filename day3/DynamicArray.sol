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
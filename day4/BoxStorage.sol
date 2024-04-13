/*

- Exercise
    - Create contract named `BoxStorage`
    - Create struct `Box` containing width, length and height
    - Declare `minimumSizeInCm` and assign some value
    - Declare array of Boxes
    - Declare 3 errors WrongLength, WrongHeight and WrongWidth with parameters
        - providedSize
        - requiredMinSize
    - Create a function `createBox` with 3 size parameters, 
    check for each of them if the required minimum was provided, 
    if not then revert with specific error, 
    if yes then add new Box to array

*/

pragma solidity 0.8.25;

contract BoxStorage {

    struct Box {
        uint256 width;
        uint256 length;
        uint256 height;
    }

    uint256 minimumSizeInCm = 10;
    Box[] private boxes;
    error WrongLength(uint256 length, requiredMinimumSize);
    error WrongHeight(uint256 height, requiredMinimumSize);
    error WrongWidth(uint256 width, requiredMinimumSize);

    function createBox(uint256 length, uint256 width, uint256 height) external {
        if (width < minimumSizeInCm) {
            revert WrongWidth(width, minimumSizeInCm)
        }

        if (length < minimumSizeInCm) {
            revert WrongLength(length, minimumSizeInCm)
        }

        if(height < minimumSizeInCm) {
            revert WrongHeight(height, minimumSizeInCm);
        }

        boxes.push(Box(width, length, height));
    }

}
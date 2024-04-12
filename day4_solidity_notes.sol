pragma solidity 0.8.25;

contract SimpleStruct {
    struct User {
        uint256 id;
        string username;
    }

    User[] private users;
    User private user;

    uint256 public nextUserId = 1;

    function createUser(string memory _username) public {

        // Solution 1, property order matters
        User memory newUser = User(nextUserId, _username);
        users.push(newUser);

        // Solution 2
        users.push(User(nextUserId, _username));

        // Solution 3, property order doesn't matter
        user = User(
            {
                username: _username,
                id: nextUserId
            }
        );

        // Solution 4
        user.id = nextUserId;
        user.username = _username;

        nextUserId++;
    }

    function getFullUser(uint256 index) public view returns(User memory) {
        require(index < users.length);
        return users[index];
    }

    function getAllUsers() public view returns(User[] memory) {
        return users;
    }
}

/*

- Exercise
    - Create contract named `Library`
    - Create struct named `Book` with properties
        - string title
        - string author
        - uint256 pages
    - Create function `createBook` which will add new Book to an array
    - Create function `getBook` which will add return book at specific index as separated properties
    - Create function `getFullBook` which will return Book at specific index
    - Create function `getAllBooks` which will return whole array of Books

*/

contract Library {
    struct Book {
        string title;
        string author;
        uint256 pages;
    }

    Book[] private books;
    Book private book;

        book = Book(
            {
                title: _title,
                author: _author,
                pages: _pages
            }
        )
        books.push(book)
    }

    function getBook(uint256 index) external view returns(string memory, string memory, uint256) {
        return (books[index].title, books[index].author, books[index].pages);
    }

    function getFullBook(uint256 index) external view returns(Book memory) {
        require(index < books.length);
        return books[index];
    }

    function getAllBooks() public view returns(Book[] memory) {
        return books;
    }
}

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


Exercise for the interfaces:

pragma solidity 0.8.25;

import {IMyStorage} from "./IMyStorage.sol";

contract DataChanger {

    IMyStorage public myStorage;
    // address public myStorageAddress;

    constructor(address _myStorageAddress) {
        // myStorageAddress = _myStorageAddress;
        myStorage = IMyStorage(_myStorageAddress);
    }

    function changeData(uint256 someNewData) external {
        // (bool success, ) = myStorageAddress.call(abi.encodeWithSignature("changeData(uint256", someNewData)); // to communicate with another contract
        // require(success);

        myStorage.changeData(someNewData);
    }

    function makeDeposit() external payable {
        // (bool success, ) = payable(myStorageAddress).call{value: msg.value(abi.encodeWithSignature("deposit()")); // to communicate with another contract
        // require(success);

        myStorage.deposit{value: msg.value}();
    }

    function test() external {
        for(uint256 i = 0; i < 10; i++) {

        }

        //while and do work the same way as in C and JS (do {} while(condition))
    }

}


// Exercise
    // Create contract Charity which
    // have a mapping for storing how much Ethers each address have sent
    // have event Donated with two params, address indexed donator and uint256 amount
    // have a function donate which will accept Ether transfers
    // require that msg.value > 0
    // update userDonations mapping
    // emit event Donated
    // Create interface ICharity for Charity
    // needs to have a donate function signature
    // Create contract Wallet which
    // have owner variable
    // have charity variable ICharity
    // have variable for percentage which will go to Charity
    // constructor, where you provide Charity address and save it in charity variable and owner of wallet
    // have a function deposit which will accept Ethers and send 5% to Charity contract
    // hint: to calculate percentage, let’s keep percentageRate = 50, then amount to charity can be calculated by (msg.value * charityPercentage) / 1000;
    // have a function withdraw which will withdraw specified amount by user



    pargma solidity 0.8.25;

contract Charity {
    event Donated(address indexed donator, uint256 amount);
    error NotEnoughDonationAmount();
    mapping(address => uint256) public userDonations;

    function donate() external payable {
        if(msg.value == 0) {
            revert NotEnoughDonationAmount();
        }

        userDonations[msg.sender] += msg.value;

        emit Donated(msg.sender, msg.value);
    }
}


pragma solidity 0.8.25;

interface ICharity {
    function donate() external payable;
}



pragma solidity 0.8.25;

import {ICharity} from "./ICharity.sol";

contract Wallet {
    address public owner;
    ICharity public charity;

    error CanNotDepositZeroEthers();
    error NotOwner();
    error NotEnoughMoney();
    error TransferFailed(); // custom errors cost less gas

    uint256 charityPercentage = 50;

    constructor(address _charityAddress) {
        owner = msg.sender;
        charity = ICharity(_charityAddress);
    }

    function deposit() external payable {
        if(msg.value == 0) {
            revert CanNotDepositZeroEthers();
        }

        uint256 charityAmount = (msg.value * charityPercentage) / 1000;

        charity.donate{value: charityAmount}();
    }

    function withdraw(uint256 amount) external {
        if(msg.sender != owner) {
            revert NotOwner();
        }

        uint256 currentBalance = address(this).balance;
        if(amount > currentBalance) {
            revert NotEnoughMoney();
        }

        (bool success, ) = payable(owner).call{value: amount}("");

        if(!success) {
            revert TransferFailed();
        }
    }
}
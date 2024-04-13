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


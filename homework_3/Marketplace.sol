// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract Marketplace {
    struct Item {
        uint id;
        string name;
        uint price;
        address owner;
    }

    address public seller;

    event ItemListed(uint id, string name, uint price, address indexed owner);
    event ItemPurchased(uint id, string name, uint price, address indexed previousOwner, address indexed newOwner);
    event Deposited(address indexed user, uint256 value); // only 3 indexed parameters
    event Withdrawn(address indexed user, uint256 value)

    error NotEnoughEther();
    error ItemNotFound();
    error TransferFailed();
    error SellerCannotBeBuyer();
    error NotSeller();

    mapping(uint => Item) public items;
    mapping(address => uint) public ownerToItem;
    mapping(address => uint256) public userBalances;

    uint[] private itemIds;
    uint256 counter = 0;

    constructor() {
        seller = msg.sender;
    }

    function listItem(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than zero");
        counter++;
        itemIds.push(counter);
        items[counter] = Item(counter, _name, _price, payable(seller));
        emit ItemListed(counter, _name, _price, seller);
    }

    function purchaseItem(uint _itemId) external payable {
        if (_itemId > counter || _itemId <= 0) {
            revert ItemNotFound();
        }

        Item memory itemToBuy = items[_itemId];
        if (msg.value < itemToBuy.price) {
            revert NotEnoughEther();
        }

        if (msg.sender == seller) {
            revert SellerCannotBeBuyer();
        }

        (bool sent, ) = itemToBuy.owner.call{value: itemToBuy.price}("");
        if (!sent) {
            revert TransferFailed();
        }

        itemToBuy.owner = payable(msg.sender);
        emit ItemPurchased(_itemId, itemToBuy.name, itemToBuy.price, itemToBuy.owner, msg.sender);

        if (msg.value > itemToBuy.price) {
            (bool refunded, ) = msg.sender.call{value: msg.value - itemToBuy.price}("");
            if (!refunded) {
                revert TransferFailed();
            }
        }
    }

    function deposit() external payable {
        if(msg.sender != seller) {
            revert NotSeller();
        }

        userBalances[seller] += msg.value;
        emit Deposited(seller, msg.value);
    }

    function withdraw(uint amount) external {
        if(msg.sender != seller) {
            revert NotSeller();
        }

        uint256 currentBalance = address(this).balance;
        if(amount > currentBalance) {
            revert NotEnoughEther();
        }

        (bool success, ) = payable(seller).call{value: amount}("");

        if(!success) {
            revert TransferFailed();
        }
        emit Withdrawn(seller, amount);
    }

}
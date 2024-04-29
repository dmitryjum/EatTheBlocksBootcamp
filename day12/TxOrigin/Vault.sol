pragma solidity 0.8.23;

import "forge-std/console.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Vault {
    using Address for address payable;

    address public owner;

    constructor() {
        owner = tx.origin;
    }

    function withdraw(address recipient) external {
        require(tx.origin == owner, "Not an owner");
        payable(recipient).sendValue(address(this).balance);
    }

    receive() external payable {}
}
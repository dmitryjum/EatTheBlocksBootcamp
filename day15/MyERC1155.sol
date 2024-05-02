//ERC1155 - implementation with Openzeppelin

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract MyERC1155 is ERC1155 {
    using Strings for uint;
    address public owner;

    constructor(string memory baseURI) ERC1155(baseURI) {
        owner = msg.sender;
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public {
        require(msg.sender == owner, "only owner");
        _mint(account, id, amount, data);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return string.concat(super.uri(0), tokenId.toString());
    }
}
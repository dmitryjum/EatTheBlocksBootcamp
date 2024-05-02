//ERC721 - implementation with Openzeppelin, with mint() function

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract MyNFT is ERC721 {
    using Strings for uint256;
    
    string private _baseURIVal;
    uint private nextTokenId;

    event Mint(address owner, uint tokenId);
    
    constructor(string memory name, string memory symbol, string memory baseURIVal) ERC721(name, symbol) {
        _baseURIVal = baseURIVal;
    }

    function mint() public payable {
        require(msg.value == 1 ether, "You need to pay exactly 1 ETH");
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string.concat(_baseURI(), tokenId.toString());
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIVal;
    }
}
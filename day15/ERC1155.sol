//ERC1155 - implementation from scratch

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract ERC1155 {
    mapping(address => mapping(uint256 => uint256)) internal _balances;
    mapping(uint256 => mapping(address => bool)) private _operators;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    string public _uri;
    
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    constructor(string memory baseURI) {
	    _uri = baseURI;
	  }
    
    function balanceOf(address account, uint256 id) public view returns (uint256) {
        return _balances[account][id];
    }
    
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view returns (uint256[] memory) {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
        
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }
        return batchBalances;
    }
    
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    
    function isApprovedForAll(address account, address operator) public view returns (bool) {
        return _operatorApprovals[account][operator];
    }
    
    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) public {
        require((msg.sender == from) || isApprovedForAll(from, msg.sender), "ERC1155: caller is not approved");
        
        _transfer(from, to, id, value);
        
        if (to.isContract()) {
            require(_checkOnERC1155Received(from, to, id, value, data), "ERC1155: transfer to non ERC1155Receiver implementer");
        }
    }
    
    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) public {
        require(ids.length == values.length, "ERC1155: ids and values length mismatch");
        require((msg.sender == from) || isApprovedForAll(from, msg.sender), "ERC1155: caller is not approved");
        
        _batchTransfer(from, to, ids, values);
        
        if (to.isContract()) {
            require(_checkOnERC1155BatchReceived(from, to, ids, values, data), "ERC1155: batch transfer to non ERC1155Receiver implementer");
        }
    }
    
    function _transfer(address from, address to, uint256 id, uint256 value) internal {
        _balances[from][id] -= value;
        _balances[to][id] += value;
        
        emit TransferSingle(msg.sender, from, to, id, value);
    }
    
    function _batchTransfer(address from, address to, uint256[] memory ids, uint256[] memory values) internal {
        for (uint256 i = 0; i < ids.length; i++) {
            _transfer(from, to, ids[i], values[i]);
        }
        
        emit TransferBatch(msg.sender, from, to, ids, values);
    }
    
    function _checkOnERC1155Received(address from, address to, uint256 id, uint256 value, bytes memory data) internal returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes4 retval = IERC1155Receiver(to).onERC1155Received(msg.sender, from, id, value, data);
        return (retval == _ERC1155_RECEIVED);
    }
    
    function _checkOnERC1155BatchReceived(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes4 retval = IERC1155Receiver(to).onERC1155BatchReceived(msg.sender, from, ids, values, data);
        return (retval == _ERC1155_BATCH_RECEIVED);
    }
    
    bytes4 constant private _ERC1155_RECEIVED = bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    bytes4 constant private _ERC1155_BATCH_RECEIVED = bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
}

interface IERC1155Receiver {
    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes memory data) external returns (bytes4);
    function onERC1155BatchReceived(address operator, address from, uint256[] memory ids, uint256[] memory values, bytes memory data) external returns (bytes4);
}

contract MyERC1155 is ERC1155 {
		address public owner;
    constructor(string memory baseURI) ERC1155(baseURI) {}
    
    function mint(address account, uint256 id, uint256 amount) public {
        require(msg.sender == owner, "only owner");
        
        _balances[account][id] += amount;
        
        emit TransferSingle(msg.sender, address(0), account, id, amount);
    }
}
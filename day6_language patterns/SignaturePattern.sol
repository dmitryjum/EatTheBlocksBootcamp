//Signature pattern

//Lesson
contract Signature {
    function foo(bytes memory sig, address from, uint a, uint b) external {
        bytes32 message = _prefixed(keccak256(abi.encodePacked(from, a, b)));
        (uint8 v, bytes32 r, bytes32 s) = _splitSignature(sig);
        address signer = ecrecover(message, v, r, s);
        require(signer != address(0) && signer == from, "wrong signature");
        //Do something with a and b
    }

    function _prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function _splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}

//Exercise - solution
contract Wallet {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(bytes memory sig, address from, address payable to, uint amount) external {
        bytes32 message = _prefixed(keccak256(abi.encodePacked(from, to, amount)));
        (uint8 v, bytes32 r, bytes32 s) = _splitSignature(sig);
        address signer = ecrecover(message, v, r, s);
        require(signer != address(0) && signer == from, "wrong signature");
        require(balances[msg.sender] >= amount, "balance too low");
        (bool result, ) = to.call{value: amount}("");
        require(result == true, "transfer failed");
    }

    function _prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function _splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}
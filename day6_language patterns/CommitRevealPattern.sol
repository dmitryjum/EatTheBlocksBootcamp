//Commit Reveal pattern

//Lesson
contract CommitReveal {
    bytes32 public hash;

    function commit(bytes32 _hash) external {
        hash = _hash;
    }

    function reveal(string memory _data) external {
        bytes32 computedHash = keccak256(abi.encodePacked(_data));
        require(computedHash == hash, "Computed hash is not the same as recorded hash");
        //Do something
    }
}

//Exercise - solution
contract CommitReveal {
    bytes32 public hash;

    function commit(bytes32 _hash) external {
        hash = _hash;
    }

    function reveal(uint a, uint b, uint c) external {
        bytes32 computedHash = keccak256(abi.encodePacked(a, b, c));
        require(computedHash == hash, "Computed hash is not the same as recorded hash");
        //Do something
    }
}
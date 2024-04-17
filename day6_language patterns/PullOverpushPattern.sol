//Pull over push pattern

//problem
contract PullOverpushPattern {
    IToken public token;
    address[] public toDistribute;
    bool public distributed;

    constructor(address _token) {
        token = IToken(_token);
    }

    function invest() external payable {
        require(msg.value >= 1 ether, "not enough ether");
        toDistribute.push(msg.sender);
    }

    function distribute() external {
      require(distributed == false, "already distributed");
      for(uint = 0; i < toDistribute.length; i++) {
        token.transfer(toDistribute[i], 10**18); //arbitrary amount, just for example
      }
      distributed = true;
    }
}

//solution
contract PullOverpushPattern {
    IToken public token;
    mapping(address => bool ) public toDistribute;

    constructor(address _token) {
        token = IToken(_token);
    }

    function invest() external payable {
        require(msg.value >= 1 ether, "not enough ether");
        toDistribute[msg.sender] = true;
    }

    function withdraw() external {
        require(toDistribute[msg.sender] == true, "not in distribution list");
        toDistribute[msg.sender] = false;
        token.transfer(msg.sender, 10**18); //arbitrary number of tokens, just for example
    }
}

interface IToken {
    function transfer(address to, uint amount) external;
}
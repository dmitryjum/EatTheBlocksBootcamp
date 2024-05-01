pragma solidity 0.8.24;

contract ERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer (address indexed from, address indexed to, uint256 value);
    event Approval (address indexed owner, address indexed spender, uint256 value);

    contructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
        ) {
            name = _name;
            symbol = _symbol;
            decimals = _decimals;
            totalSupply = _initialSupply;
            balanceOf[msg.sender] = totalSupply;
            emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address _to, uint256 _value) external returns(bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success) {
        require(allowance[from][msg.sender] >= _value, "allowance too low");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to_value);
        return true;
    }

    function _transfer(address _from, address _to, uint amount) internal {
        require(_to != address(0), "No transfer to zero address");
        require(balanceOf[from] >= _value, "Not enough");
        balanceOf[_from] -= _value;
        balance[_to] += _value;
        emitTransfer(_from, _to, _value);
    }

    function approve(address _spender, uint _value) external returns (bool success) {
        allowance[msg.sender][_spender] += _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}
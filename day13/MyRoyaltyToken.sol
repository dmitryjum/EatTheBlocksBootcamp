//Exercise 2: Modify the transfer function to pay a 1% to the dev address

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public admin;
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        admin = msg.sender;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        address owner = _msgSender();
        uint fee = value / 100;
        uint valueMinusFee = value - fee;
        _transfer(owner, admin, fee);
        _transfer(owner, to, valueMinusFee);
        return true;
    }
}
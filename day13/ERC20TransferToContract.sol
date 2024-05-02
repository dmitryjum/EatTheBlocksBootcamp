//Lesson: ERC20 transfer to contract

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(
        string memory name, 
        string memory ticker, 
        uint256 initialSupply
    ) ERC20(name, ticker) {
        _mint(msg.sender, initialSupply);
    }
}

contract MyContract {
  function foo(uint amount) external {
    token.transferFrom(address(msg.sender), address(this), amount);
  }
}
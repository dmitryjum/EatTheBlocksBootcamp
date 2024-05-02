//Uniswap

//Example: provide liquidity
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract MyContract {
    address public constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    function foo(
        address _tokenA, 
        address _tokenB, 
        uint amountADesired, 
        uint amountBDesired, 
        uint amountAMin, 
        uint amountBMin) external payable {
        IERC20 tokenA = IERC20(_tokenA);
        IERC20 tokenB = IERC20(_tokenB);
        tokenA.transferFrom(msg.sender, address(this), amountADesired);
        tokenB.transferFrom(msg.sender, address(this), amountBDesired);
        tokenA.approve(UNISWAP_ROUTER_ADDRESS, amountADesired);
        tokenB.approve(UNISWAP_ROUTER_ADDRESS, amountBDesired);

        IUniswapV2Router02 router = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);

        router.addLiquidity(
            _tokenA,
            _tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            address(this),
            block.timestamp
        );
    }
}

//example: swap token vs token
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract MyContract {
    address public constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    function foo(
        address tokenIn, 
        address tokenOut, 
        uint amountIn, 
        uint amountOutMin) external {
        IERC20 token = IERC20(tokenIn);
        token.transferFrom(msg.sender, address(this), amountIn);
        token.approve(UNISWAP_ROUTER_ADDRESS, amountIn);

        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        IUniswapV2Router02 router = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        router.swapExactTokensForTokens(
	        amountIn,
	        amountOutMin,
            path,
            address(this),
            block.timestamp 
        );     
    }
}  
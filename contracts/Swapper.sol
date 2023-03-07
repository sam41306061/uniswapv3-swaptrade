// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uniswap V3 Documentation
// --> https://docs.uniswap.org/contracts/v3/guides/swaps/single-swaps

contract Swapper {
    address public owner; // person who calls it. 
    address public immutable SWAP_ROUTER; //state variable

    // way to call router without hardcoded router addresses 
    constructor(address _SWAP_ROUTER){
        SWAP_ROUTER = _SWAP_ROUTER;
        owner = msg.sender;
    }

    // inital function 
    function swap(
        address[] memory _path,
        uint24 _fee,
        uint256 _amountIn // how much we want to swap
    ) public{
        // build perams, boiler plate
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: _path[0],
                tokenOut: _path[1],
                fee: _fee,
                recipient: address(this), // can use msg.sender here to
                deadline: block.timestamp,
                amountIn: _amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // swap
       uint256 amoutOut = ISwapRouter(SWAP_ROUTER).exactInputSingle(params);
        //transfer crypto
        IERC20(_path[1]).transfer(msg.sender, amountOut);
    }
}

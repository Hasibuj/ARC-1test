// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArcDEX {
    IERC20 public token;

    constructor(address _tokenAddr) {
        token = IERC20(_tokenAddr);
    }

    // Standard Uniswap v2 pricing: yOutput = (yReserves * xInput) / (xReserves + xInput)
    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 997; // 0.3% fee
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 1000) + inputAmountWithFee;
        return numerator / denominator;
    }

    // Swap USDC (Native) for Tokens
    function usdcToTokenSwap() public payable {
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 tokensBought = getAmountOfTokens(
            msg.value, 
            address(this).balance - msg.value, 
            tokenReserve
        );

        require(token.transfer(msg.sender, tokensBought), "Transfer failed");
    }

    // Swap Tokens for USDC (Native)
    function tokenToUsdcSwap(uint256 _tokenSold) public {
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 usdcBought = getAmountOfTokens(
            _tokenSold, 
            tokenReserve, 
            address(this).balance
        );

        require(token.transferFrom(msg.sender, address(this), _tokenSold), "Transfer failed");
        payable(msg.sender).transfer(usdcBought);
    }
}

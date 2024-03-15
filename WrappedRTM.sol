// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./MintableToken.sol";
import "./BurnableToken.sol";

contract WrappedRTM is MintableToken, BurnableToken {
    constructor(address initialOwner)
        ERC20("Wrapped RTM", "wRTM")
        Ownable(initialOwner)
    {}

    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    // function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
    //     _approve(msg.sender, spender, allowance(msg.sender, spender) + addedValue);
    //     return true;
    // }

    // function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
    //     uint256 currentAllowance = allowance(msg.sender, spender);
    //     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    //     _approve(msg.sender, spender, currentAllowance - subtractedValue);
    //     return true;
    // }

    // function renounceOwnership() public view override onlyOwner {
    //     revert("Renouncing ownership is blocked");
    // }
}

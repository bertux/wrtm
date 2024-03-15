// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
abstract contract BurnableToken is ERC20 {
    
    event Burn(address indexed burner, uint256 value, bytes addr);

    /**
     * @dev Burns a specific amount of tokens.
     * @param value The amount of token to be burned.
     * @param addr RTM address.
     */
    function burn(uint256 value, bytes memory addr) public {
        require(addr.length <= 70, "Bad Addr format");
        require(addr.length >= 33, "Bad Addr format");

        _burn(_msgSender(), value);

        emit Burn(_msgSender(), value, addr);
    }

}

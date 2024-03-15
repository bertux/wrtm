// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ECDSA.sol";

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 */
abstract contract MintableToken is ERC20, Ownable {
    using ECDSA for bytes32;

    bytes32 public lastTrans;
    mapping(bytes32 => bool) internal transactions;

    event Mint(address indexed to, uint256 amount, bytes32 trans);

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     * @param trans The transaction id of the RTM transfer.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(
        address to,
        uint256 amount,
        bytes32 trans
    ) public onlyOwner returns (bool) {
        return _txMint(to, amount, trans);
    }

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     * @param trans The transaction id of the RTM transfer.
     * @param approvalData The data signed by owner.
     * @return A boolean that indicates if the operation was successful.
     */
    function relayMint(
        address to,
        uint256 amount,
        bytes32 trans,
        bytes memory approvalData
    ) public returns (bool) {
        bytes memory blob = abi.encodePacked(to, amount, trans);
        address who = keccak256(blob).toEthSignedMessageHash().recover(approvalData);
        require(who == owner(), "Wrong signer");
        return _txMint(to, amount, trans);
    }

    function whoMint(
        address to,
        uint256 amount,
        bytes32 trans,
        bytes memory approvalData
    ) public pure returns (address) {
        bytes memory blob = abi.encodePacked(to, amount, trans);
        bytes32 kec = keccak256(blob);
        bytes32 mesg = kec.toEthSignedMessageHash();
        address who = mesg.recover(approvalData);
        return who;
    }

    function msgMint(
        address to,
        uint256 amount,
        bytes32 trans
    ) public pure returns (bytes32) {
        bytes memory blob = abi.encodePacked(to, amount, trans);
        bytes32 kec = keccak256(blob);
        bytes32 mesg = kec.toEthSignedMessageHash();
        return mesg;
    }

    function _txMint(
        address to,
        uint256 amount,
        bytes32 trans
    ) internal returns (bool) {
        require(trans != bytes32(0), "Empty tx");
        require(!transactions[trans], "Existing tx");
        
        transactions[trans] = true;
        _mint(to, amount);

        emit Mint(to, amount, trans);

        return true;
    }

}
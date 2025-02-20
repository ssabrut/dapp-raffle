// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

error Raffle__NotEnoughEthToEnterRaffle();

/**
 * @title A smart contract for Raffle
 * @author Michael Eco
 * @notice This contract is for creating a sample raffle
 * @dev Implement ChainLink VRFv2.5
 */
contract Raffle {
    uint256 private immutable entranceFee;

    constructor(uint256 _entranceFee) {
        entranceFee = _entranceFee;
    }

    function enterRaffle() public payable {
        if (msg.value < entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }
    }

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return entranceFee;
    }
}

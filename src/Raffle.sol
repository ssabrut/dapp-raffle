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
    uint256 private immutable interval; // @dev The duration lottery in seconds
    uint256 private lastTimeStamp;
    address payable[] private players; // "payable" for paying ETH to the player

    event RaffleEntered(address indexed _player);

    constructor(uint256 _entranceFee, uint256 _interval) {
        entranceFee = _entranceFee;
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if (msg.value < entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }

        players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    // 1. get random number
    // 2. use random number to pick player
    function pickWinner() external {
        if (block.timestamp - lastTimeStamp < interval) {
            revert();
        }
    }

    function getEntranceFee() external view returns (uint256) {
        return entranceFee;
    }
}

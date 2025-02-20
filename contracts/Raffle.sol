// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title A smart contract for Raffle
 * @author Michael Eco
 * @notice This contract is for creating a sample raffle
 * @dev Implement Chainlink VRFv2.5
 */
contract Raffle {
    uint256 private immutable entranceFee;

    constructor(uint256 _entranceFee) {
        entranceFee = _entranceFee;
    }

    function enterRaffle() public payable {}

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return entranceFee;
    }
}

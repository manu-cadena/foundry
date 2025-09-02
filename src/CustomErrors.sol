// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CustomErrors {
    address public owner;
    uint256 public number;

    error NotOwner(address caller);
    error TooLow(uint256 sent, uint256 required);

    constructor() {
        owner = msg.sender;
    }

    function setNumber(uint256 value) public {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        } else if (value < 10) {
            revert TooLow(value, 10);
        } else {
            number = value;
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title UnburnableToken
 * @dev Contract implementing an unburnable token with claim and safe transfer functionality.
 */
contract UnburnableToken {

    // Mapping to track token balances of addresses
    mapping(address => uint256) public balances;

    // Total supply of tokens
    uint256 public totalSupply;

    // Total number of tokens claimed
    uint256 public totalClaimed;

    // Mapping to track whether an address has claimed tokens
    mapping(address => bool) private claimed;

    // Custom error for attempting to claim tokens again
    error TokensClaimed();

    // Custom error for attempting to claim tokens when all are already claimed
    error AllTokensClaimed();

    // Custom error for unsafe token transfer
    error UnsafeTransfer(address _to);

    /**
     * @dev Constructor to set the total supply of tokens.
     */
    constructor() {
        // Initialize the total supply to 100,000,000 tokens
        totalSupply = 100000000; 
    }

    /**
     * @dev Public function to claim tokens.
     * Each address can claim 1000 tokens if they haven't claimed before.
     * Reverts if all tokens have been claimed or the caller has already claimed.
     */
    function claim() public {
        if (totalClaimed >= totalSupply) {
            // Revert if all tokens have been claimed
            revert AllTokensClaimed(); 
        }
        if (claimed[msg.sender]) {
            // Revert if the caller has already claimed
            revert TokensClaimed(); 
        }

        // Increment the balance and update the claimed status
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
        claimed[msg.sender] = true;
    }

    /**
     * @dev Public function for safe token transfer.
     * Transfers tokens from the sender to the specified address if safe conditions are met.
     * @param _to The recipient address.
     * @param _amount The amount of tokens to transfer.
     */
    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0) || _to.balance == 0) {
            // Revert if the transfer is unsafe
            revert UnsafeTransfer(_to); 
        }
        // Ensure sufficient balance
        require(balances[msg.sender] >= _amount, "Insufficient balance"); 

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
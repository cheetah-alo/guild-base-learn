---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT11: Minimal Tokens

Nombre de archivo propuesto: `NFT11_MinimalToken.sol`

<details>

<summary>Requirements Minimal Tokens</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `UnburnableToken`. Add the following in storage:

* A public mapping called `balances` to store how many tokens are owned by each address
* A `public uint` to hold `totalSupply`
* A `public uint` to hold `totalClaimed`
* Other variables as necessary to complete the task

Add the following functions.

#### Constructor[​](https://docs.base.org/base-learn/docs/minimal-tokens/minimal-tokens-exercise#constructor) <a href="#constructor" id="constructor"></a>

Add a constructor that sets the total supply of tokens to 100,000,000.

#### Claim[​](https://docs.base.org/base-learn/docs/minimal-tokens/minimal-tokens-exercise#claim) <a href="#claim" id="claim"></a>

Add a `public` function called `claim`. When called, so long as a number of tokens equalling the `totalSupply` have not yet been distributed, any wallet _that has not made a claim previously_ should be able to claim 1000 tokens. If a wallet tries to claim a second time, it should revert with `TokensClaimed`.

The `totalClaimed` should be incremented by the claim amount.

Once all tokens have been claimed, this function should revert with an error `AllTokensClaimed`. (We won't be able to test this, but you'll know if it's there!)

#### Safe Transfer[​](https://docs.base.org/base-learn/docs/minimal-tokens/minimal-tokens-exercise#safe-transfer) <a href="#safe-transfer" id="safe-transfer"></a>

Implement a `public` function called `safeTransfer` that accepts an address `_to` and an `_amount`. It should transfer tokens from the sender to the `_to` address, **only if**:

* That address is not the zero address
* That address has a balance of greater than zero Base Sepolia Eth

A failure of either of these checks should result in a revert with an `UnsafeTransfer` error, containing the address.

</details>

```solidity
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
```

####

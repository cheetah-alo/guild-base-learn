---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT4: Arrays

Nombre de archivo propuesto: `NFT4_Arrays.sol`

<details>

<summary>Requirements Arrays</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Review the contract in the starter snippet called `ArraysExercise`. It contains an array called `numbers` that is initialized with the numbers 1–10. Copy and paste this into your file.

```
contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
}
```

Add the following functions:

#### Return a Complete Array[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#return-a-complete-array) <a href="#return-a-complete-array" id="return-a-complete-array"></a>

The compiler automatically adds a getter for individual elements in the array, but it does not automatically provide functionality to retrieve the entire array.

Write a function called `getNumbers` that returns the entire `numbers` array.

#### Reset Numbers[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#reset-numbers) <a href="#reset-numbers" id="reset-numbers"></a>

Write a `public` function called `resetNumbers` that resets the `numbers` array to its initial value, holding the numbers from 1-10.

note

We'll award the pin for any solution that works, but one that **doesn't** use `.push()` is more gas-efficient!

caution

Remember, _anyone_ can call a `public` function! You'll learn how to protect functionality in another lesson.

#### Append to an Existing Array[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#append-to-an-existing-array) <a href="#append-to-an-existing-array" id="append-to-an-existing-array"></a>

Write a function called `appendToNumbers` that takes a `uint[] calldata` array called `_toAppend`, and adds that array to the `storage` array called `numbers`, already present in the starter.

#### Timestamp Saving[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#timestamp-saving) <a href="#timestamp-saving" id="timestamp-saving"></a>

At the contract level, add an `address` array called `senders` and a `uint` array called `timestamps`.

Write a function called `saveTimestamp` that takes a `uint` called `_unixTimestamp` as an argument. When called, it should add the address of the caller to the end of `senders` and the `_unixTimeStamp` to `timestamps`.

tip

You'll need to research on your own to discover the correct _Special Variables and Functions_ that can help you with this challenge!

#### Timestamp Filtering[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#timestamp-filtering) <a href="#timestamp-filtering" id="timestamp-filtering"></a>

Write a function called `afterY2K` that takes no arguments. When called, it should return two arrays.

The first should return all timestamps that are more recent than January 1, 2000, 12:00am. To save you a click, the Unix timestamp for this date and time is `946702800`.

The second should return a list of `senders` addresses corresponding to those timestamps.

#### Resets[​](https://docs.base.org/base-learn/docs/arrays/arrays-exercise#resets) <a href="#resets" id="resets"></a>

Add `public` functions called `resetSenders` and `resetTimestamps` that reset those storage variables.

</details>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ArraysExercise {
    
    // Array of numbers initialized with values
    uint[] private numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Dynamic array to store timestamps
    uint[] private timestamps;

    // Dynamic array to store sender addresses
    address[] private senders;

    // Constant representing the Unix timestamp for the year 2000
    uint256 constant Y2K = 946702800;

    // Function to retrieve the array of numbers
    function getNumbers() external view returns (uint[] memory) {
        uint[] memory results = new uint[](numbers.length);
        for (uint i = 0; i < numbers.length; i++) {
            results[i] = numbers[i];
        }
        return results;
    }

    // Function to reset the numbers array to its initial values
    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    // Function to append new numbers to the numbers array
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Function to save a timestamp along with the sender's address
    function saveTimestamp(uint _unixTimestamp) public {
        timestamps.push(_unixTimestamp);
        senders.push(msg.sender);
    }

    // Function to retrieve timestamps and senders after the year 2000
    function afterY2K() public view returns (uint256[] memory, address[] memory) {
        uint256 counter = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) {
                counter++;
            }
        }

        uint256[] memory timestampsAfterY2K = new uint256[](counter);
        address[] memory sendersAfterY2K = new address[](counter);

        uint256 index = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) {
                timestampsAfterY2K[index] = timestamps[i];
                sendersAfterY2K[index] = senders[i];
                index++;
            }
        }

        return (timestampsAfterY2K, sendersAfterY2K);
    }

    // Function to reset the senders array
    function resetSenders() public {
        delete senders;
    }

    // Function to reset the timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}
```


---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT2: Control Structures

Nombre de archivo propuesto: `NFT2_ControlStructure.sol`

<details>

<summary>Requirements Control Structures</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a single contract called `ControlStructures`. It should not inherit from any other contracts and does not need a constructor. It should have the following functions:

#### Smart Contract FizzBuzz[​](https://docs.base.org/base-learn/docs/control-structures/control-structures-exercise#smart-contract-fizzbuzz) <a href="#smart-contract-fizzbuzz" id="smart-contract-fizzbuzz"></a>

Create a function called `fizzBuzz` that accepts a `uint` called `_number` and returns a `string memory`. The function should return:

* "Fizz" if the `_number` is divisible by 3
* "Buzz" if the `_number` is divisible by 5
* "FizzBuzz" if the `_number` is divisible by 3 and 5
* "Splat" if none of the above conditions are true

#### Do Not Disturb[​](https://docs.base.org/base-learn/docs/control-structures/control-structures-exercise#do-not-disturb) <a href="#do-not-disturb" id="do-not-disturb"></a>

Create a function called `doNotDisturb` that accepts a `uint` called `_time`, and returns a `string memory`. It should adhere to the following properties:

* If `_time` is greater than or equal to 2400, trigger a `panic`
* If `_time` is greater than 2200 or less than 800, `revert` with a custom error of `AfterHours`, and include the time provided
* If `_time` is between `1200` and `1259`, `revert` with a string message "At lunch!"
* If `_time` is between 800 and 1199, return "Morning!"
* If `_time` is between 1300 and 1799, return "Afternoon!"
* If `_time` is between 1800 and 2200, return "Evening!"

</details>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ControlStructures {
    // Custom error for after-hours validation
    error AfterHours(uint256 time);
    error AtLunch();

    // FizzBuzz function
    function fizzBuzz(uint _number) public pure returns (string memory response) {
        // Check if the number is divisible by both 3 and 5
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        // Check if the number is divisible by 3
        } else if (_number % 3 == 0) {
            return "Fizz";
        // Check if the number is divisible by 5
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    // Do Not Disturb function
    function doNotDisturb(uint256 _time) public pure returns (string memory result) {
        // Panic if _time is invalid
        assert(_time < 2400);

        // Custom error for after-hours
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // Lunch time check
        if (_time >= 1200 && _time <= 1259) {
            revert AtLunch();
        }

        // Time-specific responses
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // Default case (should not be reachable)
        return "Invalid time range.";
    }
}
```


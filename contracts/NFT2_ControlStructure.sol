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

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

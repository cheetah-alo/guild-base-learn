// SPDX-License-Identifier: MIT

// Importing the SillyStringUtils library
import "./SillyStringUtils.sol";

pragma solidity ^0.8.17;

/**
 * @title ImportsExercise
 * @dev Contract to manage and manipulate Haiku using SillyStringUtils library.
 */
contract ImportsExercise {

    // Using the SillyStringUtils library for string manipulation
    using SillyStringUtils for string;

    // Declaring a public variable to store a Haiku
    SillyStringUtils.Haiku public haiku;

    /**
     * @dev Function to save a Haiku.
     * @param _line1 The first line of the Haiku.
     * @param _line2 The second line of the Haiku.
     * @param _line3 The third line of the Haiku.
     */
    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    /**
     * @dev Function to retrieve the saved Haiku.
     * @return The Haiku as a SillyStringUtils.Haiku type.
     */
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    /**
     * @dev Function to append a shrugging emoji to the third line of the Haiku.
     * @return A new Haiku with the modified third line.
     */
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory newHaiku = haiku;
        newHaiku.line3 = newHaiku.line3.shruggie();
        return newHaiku;
    }
}

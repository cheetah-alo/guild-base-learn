// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Importing the Ownable contract from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AddressBook
 * @dev Contract for managing contacts with ownership controls.
 */
contract AddressBook is Ownable(msg.sender) {

    // Define a struct to represent a contact
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    // Array to store all contacts
    Contact[] private contacts;

    // Mapping to store the index of each contact in the contacts array using its ID
    mapping(uint => uint) private idToIndex;

    // Variable to keep track of the ID for the next contact
    uint private nextId = 1;

    // Custom error for when a contact is not found
    error ContactNotFound(uint id);

    /**
     * @dev Function to add a new contact.
     * @param firstName First name of the contact.
     * @param lastName Last name of the contact.
     * @param phoneNumbers Array of phone numbers for the contact.
     */
    function addContact(
        string calldata firstName,
        string calldata lastName,
        uint[] calldata phoneNumbers
    ) external onlyOwner {
        // Create a new contact with the provided details and add it to the contacts array
        contacts.push(Contact(nextId, firstName, lastName, phoneNumbers));
        // Map the ID of the new contact to its index in the array
        idToIndex[nextId] = contacts.length - 1;
        // Increment the nextId for the next contact
        nextId++;
    }

    /**
     * @dev Function to delete a contact by its ID.
     * @param id The ID of the contact to delete.
     */
    function deleteContact(uint id) external onlyOwner {
        uint index = idToIndex[id];
        // Check if the index is valid and if the contact with the provided ID exists
        if (index >= contacts.length || contacts[index].id != id) {
            revert ContactNotFound(id);
        }
        // Replace the contact to be deleted with the last contact in the array
        contacts[index] = contacts[contacts.length - 1];
        // Update the index mapping for the moved contact
        idToIndex[contacts[index].id] = index;
        // Remove the last contact from the array
        contacts.pop();
        // Delete the mapping entry for the deleted contact ID
        delete idToIndex[id];
    }

    /**
     * @dev Function to retrieve a contact by its ID.
     * @param id The ID of the contact to retrieve.
     * @return The contact details.
     * The automatically generated getter cannot handle the required logic for looking up contacts by id, 
     * handling errors, or managing the idToIndex mapping. This is why the custom getContact function is necessary 
     * and why the contract is designed as it is.
     */
    function getContact(uint id) external view returns (Contact memory) {
        uint index = idToIndex[id];
        // Check if the index is valid and if the contact with the provided ID exists
        if (index >= contacts.length || contacts[index].id != id) {
            revert ContactNotFound(id);
        }
        return contacts[index];
    }

    /**
     * @dev Function to retrieve all contacts.
     * @return An array of all contacts.
     */
    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}

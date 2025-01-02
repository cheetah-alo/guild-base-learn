---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT10: The "new" keyword\*

<details>

<summary>Requirements The "new" keyword</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Build a contract that can deploy copies of an address book contract on demand, which allows users to add, remove, and view their contacts.

You'll need to develop two contracts for this exercise and import **at least** one additional contract.

### Imported Contracts[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#imported-contracts) <a href="#imported-contracts" id="imported-contracts"></a>

Review the [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol) contract from OpenZeppelin. You'll need to use it to solve this exercise.

You may wish to use another familiar contract to help with this challenge.

### AddressBook[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#addressbook) <a href="#addressbook" id="addressbook"></a>

Create an `Ownable` contract called `AddressBook`. In it include:

* A `struct` called `Contact` with properties for:
  * `id`
  * `firstName`
  * `lastName`
  * a `uint` array of `phoneNumbers`
* Additional storage for `contacts`
* Any other necessary state variables

It should include the following functions:

#### Add Contact[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#add-contact) <a href="#add-contact" id="add-contact"></a>

The `addContact` function should be usable only by the owner of the contract. It should take in the necessary arguments to add a given contact's information to `contacts`.

#### Delete Contact[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#delete-contact) <a href="#delete-contact" id="delete-contact"></a>

The `deleteContact` function should be usable only by the owner and should delete the contact under the supplied `_id` number.

If the `_id` is not found, it should revert with an error called `ContactNotFound` with the supplied id number.

#### Get Contact[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#get-contact) <a href="#get-contact" id="get-contact"></a>

The `getContact` function returns the contact information of the supplied `_id` number. It reverts with `ContactNotFound` if the contact isn't present.

Question

For bonus points (that only you will know about), explain why we can't just use the automatically generated getter for `contacts`?

#### Get All Contacts[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#get-all-contacts) <a href="#get-all-contacts" id="get-all-contacts"></a>

The `getAllContacts` function returns an array with all of the user's current, non-deleted contacts.

caution

You shouldn't use `onlyOwner` for the two _get_ functions. Doing so won't prevent a third party from accessing the information, because all information on the blockchain is public. However, it may give the mistaken impression that information is hidden, which could lead to a security incident.

### AddressBookFactory[​](https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise/#addressbookfactory) <a href="#addressbookfactory" id="addressbookfactory"></a>

The `AddressBookFactory` contains one function, `deploy`. It creates an instance of `AddressBook` and assigns the caller as the owner of that instance. It then returns the `address` of the newly-created contract.

</details>

Para este despliegue crearemos dos archivos .sol

El primero con el nombre de archivo propuesto: `AddressBook.sol`

```solidity
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
```

El segundo con el nombre de archivo propuesto: `NFT10_AddressBookFactory.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Import the AddressBook contract to interact with it
import "./AddressBook.sol";

// Contract for creating new instances of AddressBook
contract AddressBookFactory {
    // Define a private salt value for internal use
    string private salt = "value";

    // Function to deploy a new instance of AddressBook
    function deploy() external returns (AddressBook) {
        // Create a new instance of AddressBook
        AddressBook newAddressBook = new AddressBook();

        // Transfer ownership of the new AddressBook contract to the caller of this function
        newAddressBook.transferOwnership(msg.sender);

        // Return the newly created AddressBook contract
        return newAddressBook;
    }
}
```



Una vez creados los archivos, procedemos a desplegar el segundo archivo: `NFT10_AddressBookFactory.sol.` La dirección de este contrato es la que someteremos al test para obtener el NFT. &#x20;






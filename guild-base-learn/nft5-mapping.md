---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT5: Mapping

Nombre de archivo propuesto: `NFT5_Mapping.sol`

<details>

<summary>Requirements Mapping</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a single contract called `FavoriteRecords`. It should not inherit from any other contracts. It should have the following properties:

#### State Variables[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#state-variables) <a href="#state-variables" id="state-variables"></a>

The contract should have the following state variables. It is **up to you** to decide if any supporting variables are useful.

* A public mapping `approvedRecords`, which returns `true` if an album name has been added as described below, and `false` if it has not
* A mapping called `userFavorites` that indexes user addresses to a mapping of `string` record names which returns `true` or `false`, depending if the user has marked that album as a favorite

#### Loading Approved Albums[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#loading-approved-albums) <a href="#loading-approved-albums" id="loading-approved-albums"></a>

Using the method of your choice, load `approvedRecords` with the following:

* Thriller
* Back in Black
* The Bodyguard
* The Dark Side of the Moon
* Their Greatest Hits (1971-1975)
* Hotel California
* Come On Over
* Rumours
* Saturday Night Fever

#### Get Approved Records[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#get-approved-records) <a href="#get-approved-records" id="get-approved-records"></a>

Add a function called `getApprovedRecords`. This function should return a list of all of the names currently indexed in `approvedRecords`.

#### Add Record to Favorites[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#add-record-to-favorites) <a href="#add-record-to-favorites" id="add-record-to-favorites"></a>

Create a function called `addRecord` that accepts an album name as a parameter. **If** the album is on the approved list, add it to the list under the address of the sender. Otherwise, reject it with a custom error of `NotApproved` with the submitted name as an argument.

#### Users' Lists[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#users-lists) <a href="#users-lists" id="users-lists"></a>

Write a function called `getUserFavorites` that retrieves the list of favorites for a provided `address memory`.

#### Reset My Favorites[​](https://docs.base.org/base-learn/docs/mappings/mappings-exercise#reset-my-favorites) <a href="#reset-my-favorites" id="reset-my-favorites"></a>

Add a function called `resetUserFavorites` that resets `userFavorites` for the sender."

</details>

<pre class="language-solidity"><code class="lang-solidity"><strong>// SPDX-License-Identifier: MIT
</strong>pragma solidity ^0.8.17;

/**
 * @title FavoriteRecords
 * @dev Contract to manage a list of approved music records and allow users to add them to their favorites
 */
contract FavoriteRecords {
    
    // Mapping to store whether a record is approved
    mapping(string => bool) private approvedRecords;

    // Array to store the index of approved records
    string[] private approvedRecordsIndex;

    // Mapping to store user's favorite records
    mapping(address => mapping(string => bool)) public userFavorites;

    // Mapping to store the index of user's favorite records
    mapping(address => string[]) private userFavoritesIndex;

    // Custom error to handle unapproved records
    error NotApproved(string albumName);

    /**
     * @dev Constructor that initializes the approved records list
     */
    constructor() {
        approvedRecordsIndex = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];
        for (uint i = 0; i &#x3C; approvedRecordsIndex.length; i++) {
            approvedRecords[approvedRecordsIndex[i]] = true;
        }
    }

    /**
     * @dev Returns the list of approved records
     * @return An array of approved record names
     */
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsIndex;
    }

    /**
     * @dev Adds an approved record to the user's favorites
     * @param _albumName The name of the album to be added
     */
    function addRecord(string memory _albumName) public {
        if (!approvedRecords[_albumName]) {
            revert NotApproved({albumName: _albumName});
        }
        if (!userFavorites[msg.sender][_albumName]) {
            userFavorites[msg.sender][_albumName] = true;
            userFavoritesIndex[msg.sender].push(_albumName);
        }
    }

    /**
     * @dev Returns the list of a user's favorite records
     * @param _address The address of the user
     * @return An array of user's favorite record names
     */
    function getUserFavorites(address _address) public view returns (string[] memory) {
        return userFavoritesIndex[_address];
    }

    /**
     * @dev Resets the caller's list of favorite records
     */
    function resetUserFavorites() public {
        for (uint i = 0; i &#x3C; userFavoritesIndex[msg.sender].length; i++) {
            delete userFavorites[msg.sender][userFavoritesIndex[msg.sender][i]];
        }
        delete userFavoritesIndex[msg.sender];
    }
}
</code></pre>


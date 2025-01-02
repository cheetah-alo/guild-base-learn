---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT13: ERC-721 Tokens

Nombre de archivo propuesto: `NFT13_ERC721Tokens.sol`

<details>

<summary>Requirements ERC-721 Tokens</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `HaikuNFT`. Add the following to the contract:

* A `struct` called `Haiku` to store the `address` of the `author` and `line1`, `line2`, and `line3`
* A public array to store these `haikus`
* A public `mapping` to relate `sharedHaikus` from the `address` of the wallet shared with, to the id of the Haiku NFT shared
* A public `counter` to use as the id and to track and share the total number of Haikus minted
  * If 10 Haikus have been minted, the counter should be at 11, to serve as the next id
  * Do **NOT** assign an id of 0 to a haiku
* Other variables as necessary to complete the task

Add the following functions.

#### Constructor[​](https://docs.base.org/base-learn/docs/erc-721-token/erc-721-exercise#constructor) <a href="#constructor" id="constructor"></a>

As appropriate.

#### Mint Haiku[​](https://docs.base.org/base-learn/docs/erc-721-token/erc-721-exercise#mint-haiku) <a href="#mint-haiku" id="mint-haiku"></a>

Add an `external` function called `mintHaiku` that takes in the three lines of the poem. This function should mint an NFT for the minter and save their Haiku.

Haikus must be **unique**! If any line in the Haiku has been used as any line of a previous Haiku, revert with `HaikuNotUnique()`.

You **don't** have to count syllables, but it would be neat if you did! (No promises on whether or not we counted the same as you did)

#### Share Haiku[​](https://docs.base.org/base-learn/docs/erc-721-token/erc-721-exercise#share-haiku) <a href="#share-haiku" id="share-haiku"></a>

Add a `public` function called `shareHaiku` that allows the owner of a Haiku NFT to share that Haiku with the designated `address` they are sending it `_to`. Doing so should add it to that address's entry in `sharedHaikus`.

If the sender isn't the owner of the Haiku, instead revert with an error of `NotYourHaiku`. Include the id of the Haiku in the error.

danger

Remember, everything on the blockchain is public. This sharing functionality can be expanded for features similar to allowing an app user to display the selected shared haiku on their profile.

It does nothing to prevent anyone and everyone from seeing or copy/pasting the haiku!

#### Get Your Shared Haikus[​](https://docs.base.org/base-learn/docs/erc-721-token/erc-721-exercise#get-your-shared-haikus) <a href="#get-your-shared-haikus" id="get-your-shared-haikus"></a>

Add a `public` function called `getMySharedHaikus`. When called, it should return an array containing all of the haikus shared with the caller.

If there are no haikus shared with the caller's wallet, it should revert with a custom error of `NoHaikusShared`, with no arguments.

***

caution

The contract specification contains actions that can only be performed once by a given address. As a result, the unit tests for a passing contract will only be successful the **first** time you test.

**You may need to submit a fresh deployment to pass**

</details>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Importing OpenZeppelin ERC721 contract
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

/**
 * @dev Interface for interacting with a submission contract.
 */
interface ISubmission {

    // Struct representing a haiku
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Function to mint a new haiku
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external;

    // Function to get the total number of haikus
    function counter() external view returns (uint256);

    // Function to share a haiku with another address
    function shareHaiku(uint256 _id, address _to) external;

    // Function to get haikus shared with the caller
    function getMySharedHaikus() external view returns (Haiku[] memory);
}

/**
 * @title HaikuNFT
 * @dev Contract for managing Haiku NFTs with minting and sharing functionality.
 */
contract HaikuNFT is ERC721, ISubmission {

    // Array to store haikus
    Haiku[] public haikus;

    // Mapping to track shared haikus by address and ID
    mapping(address => mapping(uint256 => bool)) public sharedHaikus;

    // Counter for the total number of haikus minted
    uint256 public haikuCounter;

    /**
     * @dev Constructor to initialize the ERC721 contract.
     * Sets the haiku counter to start from 1.
     */
    constructor() ERC721("HaikuNFT", "HAIKU") {
        haikuCounter = 1;
    }

    /**
     * @dev Function to get the total number of haikus.
     * @return The current value of the haiku counter.
     */
    function counter() external view override returns (uint256) {
        return haikuCounter;
    }

    /**
     * @dev Function to mint a new haiku.
     * Reverts if any line of the haiku is not unique.
     * @param _line1 The first line of the haiku.
     * @param _line2 The second line of the haiku.
     * @param _line3 The third line of the haiku.
     */
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external override {
        string[3] memory haikusStrings = [_line1, _line2, _line3];

        for (uint256 li = 0; li < haikusStrings.length; li++) {
            string memory newLine = haikusStrings[li];
            for (uint256 i = 0; i < haikus.length; i++) {
                Haiku memory existingHaiku = haikus[i];
                string[3] memory existingHaikuStrings = [
                    existingHaiku.line1,
                    existingHaiku.line2,
                    existingHaiku.line3
                ];

                for (uint256 eHsi = 0; eHsi < 3; eHsi++) {
                    string memory existingHaikuString = existingHaikuStrings[eHsi];
                    if (
                        keccak256(abi.encodePacked(existingHaikuString)) ==
                        keccak256(abi.encodePacked(newLine))
                    ) {
                        revert HaikuNotUnique();
                    }
                }
            }
        }

        _safeMint(msg.sender, haikuCounter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        haikuCounter++;
    }

    /**
     * @dev Function to share a haiku with another address.
     * Reverts if the sender is not the owner of the haiku.
     * @param _id The ID of the haiku to share.
     * @param _to The address to share the haiku with.
     */
    function shareHaiku(uint256 _id, address _to) external override {
        require(_id > 0 && _id < haikuCounter, "Invalid haiku ID");

        Haiku memory haikuToShare = haikus[_id - 1];
        require(haikuToShare.author == msg.sender, "NotYourHaiku");

        sharedHaikus[_to][_id] = true;
    }

    /**
     * @dev Function to get haikus shared with the caller.
     * Reverts if no haikus are shared with the caller.
     * @return An array of Haiku structs shared with the caller.
     */
    function getMySharedHaikus()
        external
        view
        override
        returns (Haiku[] memory)
    {
        uint256 sharedHaikuCount;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                sharedHaikuCount++;
            }
        }

        Haiku[] memory result = new Haiku[](sharedHaikuCount);
        uint256 currentIndex;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                result[currentIndex] = haikus[i];
                currentIndex++;
            }
        }

        if (sharedHaikuCount == 0) {
            revert NoHaikusShared();
        }

        return result;
    }

    // Custom errors
    error HaikuNotUnique();
    error NotYourHaiku();
    error NoHaikusShared();
}
```




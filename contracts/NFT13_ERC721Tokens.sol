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

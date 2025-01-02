---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT12: ERC-20 Tokens\*

Nombre de archivo propuesto: `NFT12_ERC20Tokens.sol`\
Abajo del código del contrato tienes explicado el paso diferencial para poder desplegar bien el contrato. &#x20;

<details>

<summary>Requirements  ERC-20 Tokens</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `WeightedVoting`. Add the following:

* A `maxSupply` of 1,000,000
* Errors for:
  * `TokensClaimed`
  * `AllTokensClaimed`
  * `NoTokensHeld`
  * `QuorumTooHigh`, returning the quorum amount proposed
  * `AlreadyVoted`
  * `VotingClosed`
* A struct called `Issue` containing:
  * An OpenZeppelin Enumerable Set storing addresses called `voters`
  * A string `issueDesc`
  * Storage for the number of `votesFor`, `votesAgainst`, `votesAbstain`, `totalVotes`, and `quorum`
  * Bools storing if the issue is `passed` and `closed`

caution

The unit tests require this `struct` to be constructed with the variables in the order above.

* An array of `Issue`s called `issues`
* An `enum` for `Vote` containing:
  * `AGAINST`
  * `FOR`
  * `ABSTAIN`
* Anything else needed to complete the tasks

Add the following functions.

#### Constructor[​](https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise#constructor) <a href="#constructor" id="constructor"></a>

Initialize the ERC-20 token and burn the zeroeth element of `issues`.

#### Claim[​](https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise#claim) <a href="#claim" id="claim"></a>

Add a `public` function called `claim`. When called, so long as a number of tokens equalling the `maximumSupply` have not yet been distributed, any wallet _that has not made a claim previously_ should be able to claim 100 tokens. If a wallet tries to claim a second time, it should revert with `TokensClaimed`.

Once all tokens have been claimed, this function should revert with an error `AllTokensClaimed`.

caution

In our simple token, we used `totalSupply` to mint our tokens up front. The ERC20 implementation we're using also tracks `totalSupply`, but does it differently.

Review the docs and code comments to learn how.

#### Create Issue[​](https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise#create-issue) <a href="#create-issue" id="create-issue"></a>

Implement an `external` function called `createIssue`. It should add a new `Issue` to `issues`, allowing the user to set the description of the issue, and `quorum` - which is how many votes are needed to close the issue.

Only token holders are allowed to create issues, and issues cannot be created that require a `quorum` greater than the current total number of tokens.

This function must return the index of the newly-created issue.

caution

One of the unit tests will break if you place your check for `quorum` before the check that the user holds a token. The test compares encoded error names, which are **not** human-readable. If you are getting `-> AssertionError: �s is not equal to �9�` or similar, this is likely the issue.

#### Get Issue[​](https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise#get-issue) <a href="#get-issue" id="get-issue"></a>

Add an `external` function called `getIssue` that can return all of the data for the issue of the provided `_id`.

`EnumerableSet` has a `mapping` underneath, so it can't be returned outside of the contract. You'll have to figure something else out.

Hint

The return type for this function should be a `struct` very similar to the one that stores the issues.

#### Vote[​](https://docs.base.org/base-learn/docs/erc-20-token/erc-20-exercise#vote) <a href="#vote" id="vote"></a>

Add a `public` function called `vote` that accepts an `_issueId` and the token holder's vote. The function should revert if the issue is closed, or the wallet has already voted on this issue.

Holders must vote all of their tokens for, against, or abstaining from the issue. This amount should be added to the appropriate member of the issue and the total number of votes collected.

If this vote takes the total number of votes to or above the `quorum` for that vote, then:

* The issue should be set so that `closed` is true
* If there are **more** votes for than against, set `passed` to `true`

</details>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// Importing OpenZeppelin contracts for ERC20 and EnumerableSet functionalities
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title WeightedVoting
 * @dev Contract for weighted voting using ERC20 tokens.
 */
contract WeightedVoting is ERC20 {

    // Using EnumerableSet for address set functionality
    using EnumerableSet for EnumerableSet.AddressSet;

    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 proposedQuorum);
    error AlreadyVoted();
    error VotingClosed();

    // Struct to represent a voting issue
    struct Issue {
        EnumerableSet.AddressSet voters; // Set of voters
        string issueDesc; // Description of the issue
        uint256 quorum; // Quorum required to close the issue
        uint256 totalVotes; // Total number of votes casted
        uint256 votesFor; // Total votes in favor
        uint256 votesAgainst; // Total votes against
        uint256 votesAbstain; // Total abstained votes
        bool passed; // Whether the issue passed
        bool closed; // Whether the issue is closed
    }

    // Struct to serialize a voting issue for external view
    struct SerializedIssue {
        address[] voters; // Array of voters
        string issueDesc; // Description of the issue
        uint256 quorum; // Quorum required to close the issue
        uint256 totalVotes; // Total number of votes casted
        uint256 votesFor; // Total votes in favor
        uint256 votesAgainst; // Total votes against
        uint256 votesAbstain; // Total abstained votes
        bool passed; // Whether the issue passed
        bool closed; // Whether the issue is closed
    }

    // Enum for different vote options
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // Array to store all issues
    Issue[] internal issues;

    // Mapping to track if tokens are claimed by an address
    mapping(address => bool) public tokensClaimed;

    // Maximum supply of tokens
    uint256 public maxSupply = 1000000;

    // Amount of tokens to be claimed
    uint256 public claimAmount = 100;

    /**
     * @dev Constructor to initialize ERC20 token with name and symbol.
     * Adds an empty issue to ensure proper indexing.
     */
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push(); // Adding an empty issue to start indexing from 1
    }

    /**
     * @dev Function to claim tokens.
     * Reverts if all tokens have been claimed or caller has already claimed.
     */
    function claim() public {
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true;
    }

    /**
     * @dev Function to create a new voting issue.
     * @param _issueDesc Description of the issue.
     * @param _quorum Quorum required to close the issue.
     * @return The index of the newly-created issue.
     */
    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage _issue = issues.push();
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;

        return issues.length - 1;
    }

    /**
     * @dev Function to get details of a voting issue.
     * @param _issueId ID of the issue.
     * @return SerializedIssue containing issue details.
     */
    function getIssue(uint256 _issueId) external view returns (SerializedIssue memory) {
        Issue storage _issue = issues[_issueId];
        return SerializedIssue({
            voters: _issue.voters.values(),
            issueDesc: _issue.issueDesc,
            quorum: _issue.quorum,
            totalVotes: _issue.totalVotes,
            votesFor: _issue.votesFor,
            votesAgainst: _issue.votesAgainst,
            votesAbstain: _issue.votesAbstain,
            passed: _issue.passed,
            closed: _issue.closed
        });
    }

    /**
     * @dev Function to cast a vote on a voting issue.
     * @param _issueId ID of the issue to vote on.
     * @param _vote The vote (AGAINST, FOR, ABSTAIN).
     */
    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];

        if (_issue.closed) {
            revert VotingClosed();
        }
        if (_issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 nTokens = balanceOf(msg.sender);
        if (nTokens == 0) {
            revert NoTokensHeld();
        }

        if (_vote == Vote.AGAINST) {
            _issue.votesAgainst += nTokens;
        } else if (_vote == Vote.FOR) {
            _issue.votesFor += nTokens;
        } else {
            _issue.votesAbstain += nTokens;
        }

        _issue.voters.add(msg.sender);
        _issue.totalVotes += nTokens;

        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true;
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true;
            }
        }
    }
}
```

**En Deploy** dale a la fecha de desplegar y escribe el nombre del token y el ticker que quieres desplegar, en la imagen verás Token1 y ticker TK1. No tienes que poner ese mismo, sé creativo y lanzate a crear tu propio token en la red de Base Sepolia.

<figure><img src="../.gitbook/assets/Captura de pantalla 2024-12-30 a las 11.36.29.png" alt=""><figcaption></figcaption></figure>

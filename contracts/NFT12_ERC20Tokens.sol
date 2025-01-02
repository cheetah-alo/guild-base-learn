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

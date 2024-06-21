// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address => bool) public voters;
    Proposal[] public proposals;

    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can call this function.");
        _;
    }

    function registerVoter(address voter) public onlyChairperson {
        require(!voters[voter], "Voter is already registered.");
        voters[voter] = true;
    }

    function vote(uint proposal) public {
        require(voters[msg.sender], "You are not a registered voter.");
        require(proposal < proposals.length, "Invalid proposal.");
        proposals[proposal].voteCount += 1;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
        assert(winningVoteCount > 0); // There should be at least one vote
    }

    function endVoting() public onlyChairperson {
        if (proposals.length == 0) {
            revert("No proposals found.");
        }

        for (uint i = 0; i < proposals.length; i++) {
            delete proposals[i];
        }

        delete proposals;
    }
}

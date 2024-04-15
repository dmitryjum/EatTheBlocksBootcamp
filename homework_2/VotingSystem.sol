// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract VotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    event VoteCasted(address indexed voter, uint candidateId);
    event CandidateAdded(uint candidateId, string name);
    event ElectionWinner(uint id, string name, uint voteRatio);

    error AlreadyVoted();
    error CandidateIdNotFound();
    error NoVotesCasted();

    mapping(uint => Candidate) public candidates;
    mapping(address => uint) public voterToCandidate;

    uint[] private candidateIds;
    uint256 counter = 0;
    Candidate winner;

    modifier newVoter() {
        if (voterToCandidate[msg.sender] != 0) {
            revert AlreadyVoted();
        }
        _;
    }

    modifier existingCandidate(uint _candidateId) {
        if (_candidateId > counter || _candidateId <= 0) {
            revert CandidateIdNotFound();
        }
        _;
    }

    modifier votesCasted() {
        if (getTotalVotesNumber() == 0) {
            revert NoVotesCasted();
        }
        _;
    }
    
    function addCandidate(string memory _name) public {
        counter++;
        candidateIds.push(counter);
        candidates[counter] = Candidate(counter, _name, 0);
        emit CandidateAdded(counter, _name);
    }

    function vote(uint _candidateId) public newVoter existingCandidate(_candidateId) {
        candidates[_candidateId].voteCount++;
        voterToCandidate[msg.sender] = _candidateId;
        emit VoteCasted(msg.sender, _candidateId);
    }

    function getTotalVotesNumber() public view returns(uint) {
        uint totalVoteNumber = 0;
        for (uint i = 0; i < counter; i++) {
            totalVoteNumber += candidates[candidateIds[i]].voteCount;
        }

        return totalVoteNumber;
    }

    function determineTheWinner() external votesCasted returns(Candidate memory) {
        Candidate memory maxVoter = candidates[candidateIds[0]];
        for (uint i = 0; i < counter; i++) {
            if (candidates[candidateIds[i]].voteCount > maxVoter.voteCount) {
                maxVoter = candidates[candidateIds[i]];
            }
        }

        emit ElectionWinner(maxVoter.id, maxVoter.name, maxVoter.voteCount);
        return winner;
    }
}
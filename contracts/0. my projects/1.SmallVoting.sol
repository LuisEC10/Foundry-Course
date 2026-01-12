// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

struct Voter {
    bool voted;
    uint vote;
}

error NoValidOption();
error AlreadyVoted();

contract SmallVoting {
    mapping(address => Voter) public votes;

    uint256 public totalForVotes = 0;
    uint256 public totalAgainstVotes = 0;
    uint256 public blankVotes = 0;

    function vote(uint _vote) public {
        if(votes[msg.sender].voted){
            revert AlreadyVoted();
        }
        votes[msg.sender].voted = true;
        votes[msg.sender].vote = _vote;

        if(_vote == 1){
            totalForVotes++;
        }else if(_vote == 0) {
            totalAgainstVotes++;
        }else if(_vote == 2){
            blankVotes++;
        }else {
            revert NoValidOption();
        }
    }

    function _castBlankVote() internal {
        vote(2);
    }

    receive() external payable {
        _castBlankVote();
    }

    fallback() external payable {
        _castBlankVote();
    }
}

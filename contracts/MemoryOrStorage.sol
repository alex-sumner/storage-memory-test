// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MemoryOrStorage {
    
    uint256 public constant QUORUM = 4; // 1/4 = 25% 
    uint256 public totalMembers;

    struct Receipt {
        bool hasVoted;
        bool support; // no abstain, more here : ./DecisionsAndFlaws.md
    }

    struct Proposal {
        // slot 1
        uint128 startBlock; // @dev packed, by using lower uint : 2**128 -1 is huge
        uint128 endBlock;
        // slot 2
        address proposer;
        bool executed;
        bool canceled;
        // slot 3
        uint128 forVotes;
        uint128 againstVotes;
        // mapping(address => Receipt) receipts;
    }

    mapping(uint256 => Proposal) public proposals;

    error InvalidProposal(string reason);

    enum ProposalState {
        Executed,
        Canceled,
        Pending,
        Active,
        Succeeded,
        Defeated
    }

        constructor(/*address addr1, address addr2, address addr3, address addr4*/) {
        //dummy data for test
        totalMembers = 100;
        for (uint i = 0; i < 10; i++) {
            bool OneInFour = i % 4 == 3;
            proposals[i].startBlock = 123;
            proposals[i].endBlock = 456;
            proposals[i].proposer = address(this);
            proposals[i].executed = OneInFour;
            proposals[i].canceled =  OneInFour;
            proposals[i].forVotes = uint128(OneInFour ? i * 10 : 1 * 5);
            proposals[i].againstVotes = uint128(OneInFour ? i * 10 : 1 * 5);
            // proposals[i].receipts[addr1] = Receipt(true, true);
            // proposals[i].receipts[addr2] = Receipt(true, false);           
            // proposals[i].receipts[addr3] = Receipt(true, false);
            // proposals[i].receipts[addr4] = Receipt(true, false);
        }
    }
    
    function stateStorage(uint256 proposalId) public returns (ProposalState) {
        Proposal storage p = proposals[proposalId];

        if (p.executed) return ProposalState.Executed;
        if (p.canceled) return ProposalState.Canceled;
        if (p.startBlock == 0) revert InvalidProposal("NotDefined");
        if (p.startBlock >= block.number) return ProposalState.Pending;
        if (p.endBlock >= block.number) return ProposalState.Active;
        if (_isSucceeded(p)) return ProposalState.Succeeded;
        return ProposalState.Defeated;
    }

    function stateMemory(uint256 proposalId) public returns (ProposalState) {
        Proposal memory p = proposals[proposalId];

        if (p.executed) return ProposalState.Executed;
        if (p.canceled) return ProposalState.Canceled;
        if (p.startBlock == 0) revert InvalidProposal("NotDefined");
        if (p.startBlock >= block.number) return ProposalState.Pending;
        if (p.endBlock >= block.number) return ProposalState.Active;
        if (_isSucceeded(p)) return ProposalState.Succeeded;
        return ProposalState.Defeated;
    }

    function _isSucceeded(Proposal memory proposal) internal view returns (bool) {

        // Why quorum considering forVotes and not total turnout ? like compound
        // reason here : ./DecisionsAndFlaws.md

        uint256 quorumVotes = totalMembers / QUORUM;
        if(proposal.forVotes > proposal.againstVotes &&
        proposal.forVotes >= quorumVotes
        ) return true;
        else
        return false;
    }

}

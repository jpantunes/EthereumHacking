pragma solidity ^0.4.19;

import "./interfaces/Verifier.sol";

//Soidity WarGame, based on OpenZeppelin's Ethernaut
//GitHub - github.com/EthereumAuthio/wargame
contract WarGame {

  //Permissioned owner - can update challenges
  address public owner;

  //Reppresents a deployed challenge. Instances are deployed through the verifier's "deploy" function
  struct Deploy {
    address verifier_address;
    uint wei_amount;
  }

  //The last challenge currently deployed
  uint public last_index = 0;
  //Maps challenge indices to deployed challenge structs
  mapping (uint => Deploy) public deployed_challenges;

  //Represents a challenger's challenge intance for a given challenge index
  struct Challenge {
    uint index;
    address deployed_to;
  }

  //The challenge a challenger is currently working on
  mapping (address => Challenge) public current_challenge;
  //Which challenges a challenger has completed
  mapping (address => mapping(uint => bool)) public completed_challenges;
  //Whether the challenger has achieved total completion
  mapping (address => bool) public total_completion;

  //Event  - total challenge completion
  event TotalCompletion(address challenger, uint final_index, string message);

  //Modifier - sender must be the owner
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  //Constructor - sets the sender as the owner, and underflows last_index so that the first challenge added has an index of 0
  function WarGame() public payable {
    owner = msg.sender;
    last_index--; //Underflows last_index so the first challenge added sits at index 0
  }

  //Used to refill the contract
  function () public payable {}

  /*
  *
  * Allows a challenger to get a specific challenge (via an index).
  * If the challenger's current challenge is comlpeted, it will be added to their completed_challenges mapping
  * If all challenges have been completed, this will return 0x0 and emit the TotalCompletion event
  * If there are more challenges, this function will return the address of the next deployed instance (which can also be seen in the challenger's current_challenge mapping)
  *
  */
  function getChallenge(uint _index) public returns (address deployed) {
    require(_index <= last_index);
    //If the sender has not deployed a contract yet:
    if (current_challenge[msg.sender].deployed_to == address(0)) {
      uint amt = deployed_challenges[0].wei_amount;
      deployed = Verifier(deployed_challenges[0].verifier_address).deploy.value(amt)();
      current_challenge[msg.sender] = Challenge({
        index: 0,
        deployed_to: deployed
      });
      return deployed;
    }

    //Check if the current challenge is complete

    uint current_idx = current_challenge[msg.sender].index;
    //If the challenge is completed:
    if (verifyCurrent(msg.sender)) {
      //Set the sender's index for this challenge to true
      completed_challenges[msg.sender][current_idx] = true;

      //Check for total completion:
      bool total = true;
      for (uint i = 0; i <= last_index; i++) {
        if (!completed_challenges[msg.sender][i]) {
          total = false;
          break;
        }
      }

      //If the sender has completed all challenges, set their total_completion to true and return 0x0
      if (total) {
        total_completion[msg.sender] = true;
        TotalCompletion(msg.sender, last_index, "Congratulations! You have completed every challenge.");
        return 0x0;
      }
    }

    //If the sender has not completed all challenges, deploy their requested challenge and update current_challenge
    amt = deployed_challenges[_index].wei_amount;
    deployed = Verifier(deployed_challenges[_index].verifier_address).deploy.value(amt)();
    current_challenge[msg.sender] = Challenge({
      index: _index,
      deployed_to: deployed
    });
    return deployed;
  }

  //Allows an admin to add a new challenge to the last index
  function addChallenge(address _verifier_addr, uint _amount_to_send) public onlyOwner() {
    last_index++;
    deployed_challenges[last_index] = Deploy({
      verifier_address: _verifier_addr,
      wei_amount: _amount_to_send
    });
  }

  //Allows an admin to update a challenge with a new deployer address
  function updateChallenge(uint _idx, address _verifier_addr, uint _amount_to_send) public onlyOwner() {
    require(_idx <= last_index);
    deployed_challenges[_idx] = Deploy({
      verifier_address: _verifier_addr,
      wei_amount: _amount_to_send
    });
  }

  //Allow a challenger to verify whether they have completed their current challenge
  function verifyCurrent(address _challenger) public constant returns (bool success) {
    uint index = current_challenge[_challenger].index;
    require(deployed_challenges[index].verifier_address != 0);
    Verifier verifier = Verifier(deployed_challenges[index].verifier_address);
    address deployed = current_challenge[_challenger].deployed_to;
    return verifier.verify(deployed, _challenger);
  }

}

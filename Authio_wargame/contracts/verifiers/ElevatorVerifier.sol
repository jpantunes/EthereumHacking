pragma solidity ^0.4.19;

import "./Elevator.sol";
import "../interfaces/Verifier.sol";

//For use with Elevator.sol - deploys and verifies instances of the challenge
contract ElevatorVerifier is Verifier {

  //Allows the central contract to deploy a new Elevator instance
  function deploy() public payable returns (address deployed) {
    deployed = new Elevator();
  }

  /*
  *
  * Verifies a deployed Elevator contract
  * Requirements:
  * 1. Elevator.top() must be true
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool success) {
    Elevator deployed = Elevator(_deployed);
    _challenger;
    return deployed.top();
  }
}

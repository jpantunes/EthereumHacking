pragma solidity ^0.4.19;

import "../interfaces/Verifier.sol";
import "./Psychic.sol";

//For use with Psychic.sol - deploys the contract and verifies the solution when prompted
contract PsychicVerifier is Verifier {

  //Allows the central contract to deploy a new instance of Psychic.sol
  function deploy() public payable returns (address deployed) {
    deployed = new Psychic();
  }

  /*
  *
  * Verifies a deployed Psychic contract
  * Requirements:
  * 1. is_psychic(challenger) must be true
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool success) {
    Psychic deployed = Psychic(_deployed);
    if (!deployed.is_psychic(_challenger))
      return false;

    return true;
  }
}

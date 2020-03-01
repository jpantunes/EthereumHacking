pragma solidity ^0.4.19;

import "./King.sol";
import "../interfaces/Verifier.sol";

/*
*
* For use with King.sol - deploys the contract and verifies the solution when prompted
*
*/
contract KingVerifier is Verifier {

  function () public payable {}

  //Allows the central contract to deploy a new instance of Force.sol
  function deploy() public payable returns (address deployed) {
    deployed = (new King).value(msg.value)();
  }

  /*
  *
  * Verifies a deployed King contract
  * Requirements:
  * 1. Sending to the king must be impossible
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool success) {
    King deployed = King(_deployed);
    _challenger;
    return !deployed.king().send(1 wei);
  }
}

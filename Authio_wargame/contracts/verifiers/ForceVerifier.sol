pragma solidity ^0.4.19;

import "./Force.sol";
import "../interfaces/Verifier.sol";

/*
*
* For use with Force.sol - deploys the contract and verifies the solution when prompted
*
*/
contract ForceVerifier is Verifier {

  //Allows the central contract to deploy a new instance of Force.sol
  function deploy() public payable returns (address deployed) {
    deployed = new Force();
  }

  /*
  *
  * Verifies a deployed Force contract
  * Requirements:
  * 1. Contract balance must be above 0
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool) {
    _challenger;
    return _deployed.balance > 0;
  }
}

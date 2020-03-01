pragma solidity ^0.4.19;

import "./NoRefunds.sol";
import "../interfaces/Verifier.sol";

//For use with NoRefunds.sol - deploys and verifies instances of the challenge
contract NoRefundsVerifier is Verifier {

  //Allows the central contract to deploy a new instance of NoRefunds.sol
  function deploy() public payable returns (address deployed) {
    deployed = new NoRefunds();
  }

  /*
  *
  * Verifies a deployed NoRefunds instance
  * Requirements:
  *   1. Contract's balance mapping must be 0
  *   2. Challenger's balance mapping must be 10000
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool success) {
    NoRefunds deployed = NoRefunds(_deployed);
    if (deployed.balances(_challenger) != 10000)
      return false;

    if (deployed.balances(_deployed) != 0)
      return false;

    return true;
  }
}

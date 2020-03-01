pragma solidity ^0.4.19;

import "./HostileTakeover.sol";
import "../interfaces/Verifier.sol";

/*
*
* For use with HostileTakeover.sol - deploys the contract and verifies the solution when prompted
*
*/
contract HostileTakeoverVerifier is Verifier {

  //Mirrors OwnerStatus enum in HostileTakeover.sol
  enum OwnerStatus {
    NotOwner,
    Owner
  }

  //Mirrors BlacklistStatus enum in HostileTakeover.sol
  enum BlacklistStatus {
    NotBlacklisted,
    Blacklisted
  }

  //Allows the central contract address to deploy a HostileTakeover instance, with the given value
  function deploy() public payable returns (address deployed) {
    deployed = (new HostileTakeover).value(msg.value)();
  }

  /*
  *
  * Verifies a deployed HostileTakeover challenge
  * Requirements:
  *`1. Challenger must have removed this contract as an owner`
  * 2. Challenger must have blacklisted this contract
  * 3. Challenger must have set themselves as an owner
  *
  */
  function verify(address _deployed, address _challenger) public constant returns (bool success) {
    HostileTakeover deployed = HostileTakeover(_deployed);
    //Check that this contract is blacklisted
    if (uint(deployed.blacklisted(address(this))) == uint(BlacklistStatus.NotBlacklisted))
      return false;

    //Check that this contract is no longer an owner
    if (uint(deployed.is_owner(address(this))) == uint(OwnerStatus.Owner))
      return false;

    //Check that the challenger is an owner
    if (uint(deployed.is_owner(_challenger)) != uint(OwnerStatus.Owner))
      return false;

    return true;
  }

}

pragma solidity ^0.4.19;

contract Verifier {
  address public central_contract;

  modifier onlyCentral() {
    require(msg.sender == central_contract);
    _;
  }

  function Verifier() public {
    central_contract = msg.sender;
  }

  function transferOwnership(address _new_owner) public onlyCentral() {
    central_contract = _new_owner;
  }

  function deploy() public payable returns (address deployed);
  function verify(address _deployed, address _challenger) public constant returns (bool success);
}

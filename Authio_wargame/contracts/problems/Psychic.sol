pragma solidity ^0.4.19;

/*
*
* Authio WarGame - level 04: "Psychic"
*
* Objectives:
*   1. Become psychic
*
*/
contract Empty {
}

//Psychic contract - allows proven psychics to withdraw stored Ether
contract Psychic {

  //Maps an address to whether or not the address is psychic
  mapping (address => bool) public is_psychic;

  //Modifier - only psychics may pass
  modifier onlyPsychic() {
    require(is_psychic[msg.sender]);
    _;
  }

  //Constructor
  function Psychic() public payable {
  }

  //Fallback function does not accept Ether
  function () public {
    revert();
  }

  //Allows a sender to make a prediction and prove whether they are psychic or not
  function becomePsychic(address _prediction) public {
    if (_prediction == address(new Empty()))
      is_psychic[msg.sender] = true;
  }

  //Allows proven psychics to withdraw Ether
  function withdraw() public onlyPsychic() {
    msg.sender.transfer(this.balance);
  }
}

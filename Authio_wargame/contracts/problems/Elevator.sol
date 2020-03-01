pragma solidity ^0.4.19;

/*
*
* Authio WarGame - level 02: "Elevator"
* (level based on OpenZeppelin's Ethernaut WarGame)
*
* Objectives:
*   1. Reach the top floor (set top to true)
*
*/
interface Building {
  function isLastFloor(uint) public constant returns (bool);
}

//Elevator contract - use from a Building
contract Elevator {
  //Whether the elevator is at the top or not
  bool public top;
  //The floor the elevator is on
  uint public floor;

  //Allows the Elevator to go to a floor in a building
  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

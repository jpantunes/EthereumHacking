pragma solidity ^0.4.18;

/*
*
* Authio WarGame - level 01: "King"
* (level based on OpenZeppelin's Ethernaut WarGame)
*
* Objectives:
*   1. Become the king, and make it impossible for the owner to reclaim kingship
*
*/
contract Ownable {

  //Owner - privileged address
  address public owner;

  //Modifier - sender must be contract owner
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  //Constructor: Sets the sender as the owner
  function Ownable() public {
    owner = msg.sender;
  }

  //Allows the owner to transfer ownership
  function transferOwnership(address _new_owner) public onlyOwner() {
    owner = _new_owner;
  }
}

//Simple "Ponzi-style" game - the fallback function allows participants to become King, if they submit more
//Ether than the previous king.
contract King is Ownable {

  //The address of the current king
  address public king;
  //The uint prize amount to be sent to the next king
  uint public prize;

  //Constructor: Sets the sender as the king, and the value they sent as the prize
  function King() public payable {
    king = msg.sender;
    prize = msg.value;
  }

  //Fallback function - Allows participants to become the king, if they submit more ether than the previous king
  function() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }
}

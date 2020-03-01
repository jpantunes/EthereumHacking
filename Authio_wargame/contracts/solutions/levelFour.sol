pragma solidity ^0.4.23;

import "./Psychic.sol";
// "guess" the address of an unpublished contract
// sha3(rlp.encode(deployer_address, deployer_address_nonce)) == next address
contract levelThreeAttack {

    function attack(address _victim) external returns(bool) {
        //contracts start with nonce 1, but solidity cant see that, so
        //manual adjustment needed if nonce is != 1
        uint8 nonce = 1;
        //rlp encoding faked with a little help from sigma.prime
        address guess = address(keccak256(0xd6, 0x94, _victim, nonce));
        Psychic victim = Psychic(_victim);
        victim.becomePsychic(guess);
        if (victim.is_psychic(address(this))) {
            return true;
        }
    }
}

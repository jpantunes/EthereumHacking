pragma solidity ^0.4.24;

//*** Exercice 8 ***//
// You choose Head or Tail and send 1 ETH.
// The next party send 1 ETH and try to guess what you chose.
// If it succeed it gets 2 ETH, else you get 2 ETH.
contract HeadOrTail {
    bool public chosen; // True if head/tail has been chosen.
    bool lastChoiceHead; // True if the choice is head.
    address public lastParty; // The last party who chose.

    /** @dev Must be sent 1 ETH.
     *  Choose head or tail to be guessed by the other player.
     *  @param _chooseHead True if head was chosen, false if tail was chosen.
     */
    function choose(bool _chooseHead) payable {
        require(!chosen);
        require(msg.value == 1 ether);

        chosen=true;
        lastChoiceHead=_chooseHead;
        lastParty=msg.sender;
    }


    function guess(bool _guessHead) payable {
        require(chosen);
        require(msg.value == 1 ether);

        if (_guessHead == lastChoiceHead)
            msg.sender.transfer(2 ether);
        else
            lastParty.transfer(2 ether);

        chosen=false;
    }
}


contract HeadOrTailAttack {

    HeadOrTail victim;

    constructor(address _victim) public {
        victim = HeadOrTail(_victim);
    }

    //lastChoiceHead can be read from storage through  web3.eth.getStorageAt(contractAddr, 0)

    // '0xca35b7d915458ef540ade6068dfe2f44e8fa733c0000'
    // chosen = 00 (no)
    // lastChoiceHead = 00 (no)
    // lastParty = '0xca35b7d915458ef540ade6068dfe2f44e8fa733c'

    // '0xca35b7d915458ef540ade6068dfe2f44e8fa733c0001'
    // chosen = 00 (no)
    // lastChoiceHead = 01 (yes)
    // lastParty = '0xca35b7d915458ef540ade6068dfe2f44e8fa733c'

    // '0xca35b7d915458ef540ade6068dfe2f44e8fa733c0101'
    // chosen = 01 (yes)
    // lastChoiceHead = 01 (yes)
    // lastParty = '0xca35b7d915458ef540ade6068dfe2f44e8fa733c'
    function attack() external payable returns(bool success, bytes32 key) {
        // victim.choose(_value_from_storage);
    }

}

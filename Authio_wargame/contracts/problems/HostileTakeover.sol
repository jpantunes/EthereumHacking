pragma solidity ^0.4.19;

/*
*
* Authio WarGame - level 05: Hostile Takeover
*
* Objectives:
*   1. Remove the contract's constructor-initialized owner from the is_owner mapping
*   2. Blacklist the same owner in the blacklisted mapping
*   3. Become an owner
*
*/
contract HostileTakeover {


  //Enum describes the status of an address as owner
  enum OwnerStatus {
    NotOwner,
    Owner
  }

  //Enum describes the status of an address as blacklisted
  enum BlacklistStatus {
    NotBlacklisted,
    Blacklisted
  }

  //Maps addresses to whether or not they are an owner
  mapping (address => OwnerStatus) public is_owner;
  //Maps addresses to whether or not they are blacklisted
  mapping (address => BlacklistStatus) public blacklisted;

  //Modifier - only an owner can access this function
  modifier onlyOwner() {
    require(is_owner[msg.sender] == OwnerStatus.Owner);
    _;
  }

  //Modifier - only a non-blacklisted address can access this function
  modifier isNotBlacklisted() {
    require(blacklisted[msg.sender] == BlacklistStatus.NotBlacklisted);
    _;
  }

  //Constructor - Sets the sender as an owner
  function HostileTakeover() public payable {
    is_owner[msg.sender] = OwnerStatus.Owner;
  }

  //Allows an owner to withdraw the contract's balance
  function withdraw() public onlyOwner() {
    msg.sender.transfer(this.balance);
  }

  //Allows non-blacklisted addresses to store data in the contract
  function store(bytes32 _location, bytes32 _val) public isNotBlacklisted() {
    assembly {
      sstore(_location, _val)
    }
  }
}

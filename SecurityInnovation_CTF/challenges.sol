//LEVEL 0
pragma solidity  0.4.24;

import "./CtfFramework.sol";
import "./SafeMath.sol";

contract Donation is CtfFramework{

    using SafeMath for uint256;

    uint256 public funds;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        funds = funds.add(msg.value);
    }
    
    function() external payable ctf{
        funds = funds.add(msg.value);
    }

    function withdrawDonationsFromTheSuckersWhoFellForIt() external ctf{
        msg.sender.transfer(funds);
        funds = 0;
    }

}

//LEVEL 1
pragma solidity 0.4.24;

import "./CtfFramework.sol";

contract Lockbox1 is CtfFramework{

    uint256 private pin;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        pin = now%10000;
    }
    
    function unlock(uint256 _pin) external ctf{
        require(pin == _pin, "Incorrect PIN");
        msg.sender.transfer(address(this).balance);
    }

}

// LEVEL 2
pragma solidity 0.4.24;

import "./CtfFramework.sol";
import "./SafeMath.sol";

contract PiggyBank is CtfFramework{

    using SafeMath for uint256;

    uint256 public piggyBalance;
    string public name;
    address public owner;
    
    constructor(address _ctfLauncher, address _player, string _name) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        name=_name;
        owner=msg.sender;
        piggyBalance=piggyBalance.add(msg.value);
    }
    
    function() external payable ctf{
        piggyBalance=piggyBalance.add(msg.value);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "Unauthorized: Not Owner");
        _;
    }

    function withdraw(uint256 amount) internal{
        piggyBalance = piggyBalance.sub(amount);
        msg.sender.transfer(amount);
    }

    function collectFunds(uint256 amount) public onlyOwner ctf{
        require(amount<=piggyBalance, "Insufficient Funds in Contract");
        withdraw(amount);
    }
    
}

contract CharliesPiggyBank is PiggyBank{
    
    uint256 public withdrawlCount;
    
    constructor(address _ctfLauncher, address _player) public payable
        PiggyBank(_ctfLauncher, _player, "Charlie") 
    {
        withdrawlCount = 0;
    }
    
    function collectFunds(uint256 amount) public ctf{
        require(amount<=piggyBalance, "Insufficient Funds in Contract");
        withdrawlCount = withdrawlCount.add(1);
        withdraw(amount);
    }
    
}

// LEVEL 3 
pragma solidity 0.4.24; 

import "./CtfFramework.sol";
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.8.0/contracts/token/ERC20/StandardToken.sol
import "./StandardToken.sol";

contract SIToken is StandardToken {

    using SafeMath for uint256;

    string public name = "SIToken";
    string public symbol = "SIT";
    uint public decimals = 18;
    uint public INITIAL_SUPPLY = 1000 * (10 ** decimals);

    constructor() public{
        totalSupply_ = INITIAL_SUPPLY;
        balances[this] = INITIAL_SUPPLY;
    }
}

contract SITokenSale is SIToken {

    uint256 public feeAmount;
    uint256 public etherCollection;
    address public developer;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)    
    {
        feeAmount = 10 szabo; 
        developer = msg.sender;
        purchaseTokens(msg.value);
    }

    function purchaseTokens(uint256 _value) internal{
        require(_value > 0, "Cannot Purchase Zero Tokens");
        require(_value < balances[this], "Not Enough Tokens Available");
        balances[msg.sender] += _value - feeAmount;
        balances[this] -= _value;
        balances[developer] += feeAmount; 
        etherCollection += msg.value;
    }

    function () payable external {
        purchaseTokens(msg.value);
    }

    // Allow users to refund their tokens for half price ;-)
    function refundTokens(uint256 _value) external {
        require(_value>0, "Cannot Refund Zero Tokens");
        transfer(this, _value);
        etherCollection -= _value/2;
        msg.sender.transfer(_value/2);
    }

    function withdrawEther() external {
        require(msg.sender == developer, "Unauthorized: Not Developer");
        require(balances[this] == 0, "Only Allowed Once Sale is Complete");
        msg.sender.transfer(etherCollection);
    }

}

//LEVEL 4 
pragma solidity 0.4.24;

contract SimpleBank {

    mapping(address => uint256) public balances;

    constructor(address _player) public payable
    {
        balances[msg.sender] = msg.value;
    }

    function deposit(address _user) public payable {
        balances[_user] += msg.value;
    }

    function withdraw(address _user, uint256 _value) public {
        require(_value<=balances[_user], "Insufficient Balance");
        balances[_user] -= _value;
        msg.sender.transfer(_value);
    }

    function () public payable {
        deposit(msg.sender);
    }

}

contract MembersBank is SimpleBank{ 

    mapping(address => string) public members;

    constructor(address _player) public payable SimpleBank(_player) {
    }

    function register(address _user, string _username) public {
        members[_user] = _username;
    }

    modifier isMember(address _user){
        bytes memory username = bytes(members[_user]);
        require(username.length != 0, "Member Must First Register");
        _;
    }

    function deposit(address _user) public payable isMember(_user) {
        super.deposit(_user);
    }

    function withdraw(address _user, uint256 _value) public isMember(_user) {
        super.withdraw(_user, _value);
    }

}

contract SecureBank is MembersBank{

    constructor(address _player) public payable MembersBank(_player) {
    }

    function deposit(address _user) public payable {
        require(msg.sender == _user, "Unauthorized User");
        require(msg.value < 100 ether, "Exceeding Account Limits");
        require(msg.value >= 1 ether, "Does Not Satisfy Minimum Requirement");
        super.deposit(_user);
    }

    function withdraw(address _user, uint8 _value) public {
        require(msg.sender == _user, "Unauthorized User");
        require(_value < 100, "Exceeding Account Limits");
        require(_value >= 1, "Does Not Satisfy Minimum Requirement");
        super.withdraw(_user, _value * 1 ether);
    }

    function register(address _user, string _username) public {
        require(bytes(_username).length!=0, "Username Not Enough Characters");
        require(bytes(_username).length<=20, "Username Too Many Characters");
        super.register(_user, _username);
    }
}

//LEVEL 5 
pragma solidity 0.4.24;

import "./SafeMath.sol";

contract Lottery {

    using SafeMath for uint256;

    uint256 public totalPot;

    constructor() public payable
    {
        totalPot = totalPot.add(msg.value);
    }
    
    function() external payable {
        totalPot = totalPot.add(msg.value);
    }

    function play(uint256 _seed) external payable {
        require(msg.value >= 1 finney, "Insufficient Transaction Value");
        totalPot = totalPot.add(msg.value);
        bytes32 entropy = blockhash(block.number); //NB this is always 0x00
        bytes32 entropy2 = keccak256(abi.encodePacked(msg.sender));
        bytes32 target = keccak256(abi.encodePacked(entropy^entropy2));
        bytes32 guess = keccak256(abi.encodePacked(_seed));
        if(guess==target){
            //winner
            uint256 payout = totalPot;
            totalPot = 0;
            msg.sender.transfer(payout);
        }
    }
}

//LEVEL 6
pragma solidity 0.4.24;

import "./SafeMath.sol";

contract Royalties{ 

    using SafeMath for uint256;

    address private collectionsContract;
    address private artist;

    address[] private receiver;
    mapping(address => uint256) private receiverToPercentOfProfit;
    uint256 private percentRemaining;

    uint256 public amountPaid;

    constructor(address _manager, address _artist) public
    {
        collectionsContract = msg.sender;
        artist=_artist;

        receiver.push(_manager);
        receiverToPercentOfProfit[_manager] = 80;
        percentRemaining = 100 - receiverToPercentOfProfit[_manager];
    }

    modifier isCollectionsContract() { 
        require(msg.sender == collectionsContract, "Unauthorized: Not Collections Contract");
        _;
    }

    modifier isArtist(){
        require(msg.sender == artist, "Unauthorized: Not Artist");
        _;
    }

    function addRoyaltyReceiver(address _receiver, uint256 _percent) external isArtist{
        require(_percent<percentRemaining, "Precent Requested Must Be Less Than Percent Remaining");
        receiver.push(_receiver);
        receiverToPercentOfProfit[_receiver] = _percent;
        percentRemaining = percentRemaining.sub(_percent);
    }

    function payoutRoyalties() public payable isCollectionsContract{
        for (uint256 i = 0; i< receiver.length; i++){
            address current = receiver[i];
            uint256 payout = msg.value.mul(receiverToPercentOfProfit[current]).div(100);
            amountPaid = amountPaid.add(payout);
            current.transfer(payout);
        }
        msg.sender.call.value(msg.value-amountPaid)(bytes4(keccak256("collectRemainingFunds()")));
    }

    function getLastPayoutAmountAndReset() external isCollectionsContract returns(uint256){
        uint256 ret = amountPaid;
        amountPaid = 0;
        return ret;
    }

    function () public payable isCollectionsContract{
        payoutRoyalties();
    }
}

contract Manager{
    address public owner;

    constructor(address _owner) public {
        owner = _owner;
    }

    function withdraw(uint256 _balance) public {
        owner.transfer(_balance);
    }

    function () public payable{
        // empty
    }
}

contract RecordLabel {

    using SafeMath for uint256;

    uint256 public funds;
    address public royalties;

    constructor(address _player) public payable
    {
        royalties = new Royalties(new Manager(_player), _player);
        funds = funds.add(msg.value);
    }
    
    function() external payable {
        funds = funds.add(msg.value);
    }

    function withdrawFundsAndPayRoyalties(uint256 _withdrawAmount) external {
        require(_withdrawAmount<=funds, "Insufficient Funds in Contract");
        funds = funds.sub(_withdrawAmount);
        royalties.call.value(_withdrawAmount)();
        uint256 royaltiesPaid = Royalties(royalties).getLastPayoutAmountAndReset();
        uint256 artistPayout = _withdrawAmount.sub(royaltiesPaid); 
        msg.sender.transfer(artistPayout);
    }

    function collectRemainingFunds() external payable{
        require(msg.sender == royalties, "Unauthorized: Not Royalties Contract");
    }
}

//LEVEL 7 
pragma solidity 0.4.24;

import "./CtfFramework.sol";
import "./SafeMath.sol";

contract HeadsOrTails is CtfFramework{

    using SafeMath for uint256;

    uint256 public gameFunds;
    uint256 public cost;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        gameFunds = gameFunds.add(msg.value);
        cost = gameFunds.div(10);
    }
    
    function play(bool _heads) external payable ctf{
        require(msg.value == cost, "Incorrect Transaction Value");
        require(gameFunds >= cost.div(2), "Insufficient Funds in Game Contract");
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if ((coinFlip == 1 && _heads) || (coinFlip == 0 && !_heads)) {
            //win
            gameFunds = gameFunds.sub(msg.value.div(2));
            msg.sender.transfer(msg.value.mul(3).div(2));
        }
        else {
            //loser
            gameFunds = gameFunds.add(msg.value);
        }
    }

}

//LEVEL 8
pragma solidity 0.4.24;

import "./CtfFramework.sol";
import "./SafeMath.sol";

contract TrustFund is CtfFramework{ //ropsten 0xe7deb0c174672fe59eef44ffcd83046bc657734c

    using SafeMath for uint256;

    uint256 public allowancePerYear;
    uint256 public startDate;
    uint256 public numberOfWithdrawls;
    bool public withdrewThisYear;
    address public custodian;

    // "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"
    constructor(address _ctfLauncher, address _player) public payable 
        CtfFramework(_ctfLauncher, _player)
    {
        custodian = msg.sender;
        allowancePerYear = msg.value.div(10);        
        startDate = now;
    }

    function checkIfYearHasPassed() internal{
        if (now>=startDate + numberOfWithdrawls * 365 days){
            withdrewThisYear = false;
        } 
    }

    function withdraw() external ctf{
        require(allowancePerYear > 0, "No Allowances Allowed");
        checkIfYearHasPassed();
        require(!withdrewThisYear, "Already Withdrew This Year");
        if (msg.sender.call.value(allowancePerYear)()){
            withdrewThisYear = true;
            numberOfWithdrawls = numberOfWithdrawls.add(1);
        }
    }
    
    function returnFunds() external payable ctf{
        require(msg.value == allowancePerYear, "Incorrect Transaction Value");
        require(withdrewThisYear==true, "Cannot Return Funds Before Withdraw");
        withdrewThisYear = false;
        numberOfWithdrawls=numberOfWithdrawls.sub(1);
    }
}

//LEVEL 9
pragma solidity 0.4.24;

import "./CtfFramework.sol";
import "./SafeMath.sol";

contract SlotMachine is CtfFramework{

    using SafeMath for uint256;

    uint256 public winner;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        winner = 5 ether;
    }
    
    function() external payable ctf{
        require(msg.value == 1 szabo, "Incorrect Transaction Value");
        if (address(this).balance >= winner){
            msg.sender.transfer(address(this).balance);
        }
    }
}

//LEVEL 10 
pragma solidity 0.4.24;

import "./CtfFramework.sol";

contract DebugAuthorizer{
    
    bool public debugMode;

    constructor() public payable{
        if(address(this).balance == 1.337 ether){
            debugMode=true;
        }
    }
}

contract RainyDayFund is CtfFramework{

    address public developer;
    mapping(address=>bool) public fundManagerEnabled;
    DebugAuthorizer public debugAuthorizer;

    constructor(address _ctfLauncher, address _player) public payable
        CtfFramework(_ctfLauncher, _player)
    {
        // debugAuthorizer = (new DebugAuthorizer).value(1.337 ether)(); // Debug mode only used during development
        debugAuthorizer = new DebugAuthorizer();
        developer = msg.sender;
        fundManagerEnabled[msg.sender] = true;
    }
    
    modifier isManager() {
        require(fundManagerEnabled[msg.sender] || debugAuthorizer.debugMode() || msg.sender == developer, "Unauthorized: Not a Fund Manager");
         _;
    }

    function () external payable ctf{
        // Anyone can add to the fund    
    }
    
    function addFundManager(address _newManager) external isManager ctf{
        fundManagerEnabled[_newManager] = true;
    }

    function removeFundManager(address _previousManager) external isManager ctf{
        fundManagerEnabled[_previousManager] = false;
    }

    function withdraw() external isManager ctf{
        msg.sender.transfer(address(this).balance);
    }   
}


pragma solidity ^0.4.10;

import "./mortal.sol";
import "./hackoin.sol";

contract hackethereumIco is mortal {
    uint256 public _amountRaised;
    uint256 public _deadline;

    uint256 private _timeBetweenWithdrawCalls;
    uint256 private _timeBetweenControlFlipCalls;

    uint256 private _priceIncrease1;
    uint256 private _priceIncrease2;

    bool private _hackedTenuous;
    bool private _hackedEducated;
    bool private _hackedAdept;
    bool private _whitehatActive;
    
    address private _beneficiary;
    address private _hackerTenuous;
    address private _hackerEducated;
    address private _hackerAdept;
    address private _hackerDecisive;
    address private _whitehat;

    uint256 private _lastHack;
    uint256 private _lastWhitehat;
    uint256 private _lastControlFlip;

    uint256 private _initialPrice;

    uint256 private _participationThreshold;

    hackoin public _hackoinToken;

    mapping(address => uint256) private _balanceOf;

    event FundTransfer(address indexed backer, uint256 amount, bool isContribution);
    event Debug(string message);

    function hackethereumIco(
        address ifSuccessfulSendTo,
        address hackerTenuousAddress,
        address hackerEducatedAddress,
        address hackerAdeptAddress,
        address hackerDecisiveAddress,
        address whitehatAddress,
        uint256 durationInMinutes,
        uint256 timeBetweenWithdrawMinutes,
        uint256 timeBetweenFlipMinutes
        
    ) {
        _beneficiary = ifSuccessfulSendTo;
        _hackerTenuous = hackerTenuousAddress;
        _hackerEducated = hackerEducatedAddress;
        _hackerAdept = hackerAdeptAddress;
        _hackerDecisive = hackerDecisiveAddress;
        _whitehat = whitehatAddress;
        _deadline = now + durationInMinutes * 1 minutes; //1504231337

        _timeBetweenWithdrawCalls = timeBetweenWithdrawMinutes * 1 minutes; // 100 minutes;
        _timeBetweenControlFlipCalls = timeBetweenFlipMinutes * 1 minutes; //100 minutes;

        _priceIncrease2 = _deadline - 4 days;
        _priceIncrease1 = _priceIncrease2 - 6 days;

        _lastHack = now;//_deadline + 1 days;
        _lastWhitehat = now;//_deadline + 1 days;
        _lastControlFlip = now;//_deadline + 1 days;

        _initialPrice = 1;

        _participationThreshold = 50000000000000000; 

        Debug("Creating hackoin token");
        address tokenContractAddress = new hackoin();
        _hackoinToken = hackoin(tokenContractAddress);
        _hackoinToken.mintToken(msg.sender, _participationThreshold*2);
        Debug("ICO contract created");
    }

    function () payable {
        Debug("Funding ICO");
        require(now < _deadline);

        uint256 amount = msg.value;

        uint256 currentPrice;
        if(now < _priceIncrease1)
        {
            currentPrice = _initialPrice;
        }
        else if (now < _priceIncrease2)
        {
            currentPrice = _initialPrice * 2;
        }
        else
        {
            currentPrice = _initialPrice * 4;
        }

        require(amount / currentPrice > 0);
        require(_balanceOf[msg.sender] + amount >= _balanceOf[msg.sender]);
        require(this.balance + amount >= this.balance);

        _balanceOf[msg.sender] += amount;
        _amountRaised += amount;
        
        Debug("Paying backer");        

        _hackoinToken.mintToken(msg.sender, amount / currentPrice);
        FundTransfer(msg.sender, amount, true);
        Debug("Funding complete");
    }

    modifier afterDeadline()
    { 
        require (now >= _deadline); 
        _;
    }

    function withdrawFunds(uint256 amount) afterDeadline {
        Debug("Withdrawing");
        require(_beneficiary == msg.sender);

        require(this.balance > 0);
        require(amount <= this.balance);

        if (_beneficiary.send(amount))
        {
            FundTransfer(_beneficiary, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function hackDecisive(uint256 amount) afterDeadline {
        Debug("Withdrawing");
        require(_hackerDecisive == msg.sender);

        require(this.balance > 0);
        require(amount <= this.balance);

        if (_hackerDecisive.send(amount))
        {
            FundTransfer(_hackerDecisive, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function whitehatRecover() afterDeadline {
        Debug("Withdrawing");
        require(_whitehat == msg.sender);
        require(_whitehatActive);

        require(_lastWhitehat + _timeBetweenWithdrawCalls < now);

        require(this.balance > 0);

        uint amount;
        if(_amountRaised > 500 ether)
        {
            amount = _amountRaised / 50;
        }
        else if(_amountRaised > 100 ether)
        {
            amount = _amountRaised / 20;
        }
        else
        {
            amount = _amountRaised / 10;
        }
        
        if(amount > this.balance)
        {
            amount = this.balance;
        }

        _lastWhitehat = now;

        if (_whitehat.send(amount))
        {
            FundTransfer(_whitehat, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function hack(address targetAddress) afterDeadline {
        require(msg.data.length == 32+4);

        Debug("Withdrawing");
        require(_hackerTenuous == msg.sender || _hackerEducated == msg.sender || _hackerAdept == msg.sender);
        require(_hackedTenuous);
        require(_hackedEducated);
        require(_hackedAdept);
        require(!_whitehatActive);

        require(_lastHack + _timeBetweenWithdrawCalls < now);

        require(this.balance > 0);

        require(_hackoinToken.balanceOf(targetAddress) >= _participationThreshold);

        uint amount;
        if(_amountRaised > 500 ether)
        {
            amount = _amountRaised / 50;
        }
        else if(_amountRaised > 100 ether)
        {
            amount = _amountRaised / 20;
        }
        else
        {
            amount = _amountRaised / 10;
        }
        
        if(amount > this.balance)
        {
            amount = this.balance;
        }

        _lastHack = now;

        if (targetAddress.send(amount))
        {
            FundTransfer(targetAddress, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function hackTenuous() afterDeadline {
        require(_hackerTenuous == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        _hackedTenuous = true;

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
        }
    }

    function hackEducated() afterDeadline {
        require(_hackerEducated == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        require(_hackedTenuous);
        _hackedEducated = true;

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
        }
    }

    function hackAdept() afterDeadline {
        require(_hackerAdept == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        require(_hackedTenuous && _hackedEducated);
        _hackedAdept = true;

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
        }
    }

    function whiteHat() afterDeadline {
        require(_whitehat == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        _hackedTenuous = false;
        _hackedEducated = false;
        _hackedAdept = false;
        _whitehatActive = true;
        _lastControlFlip = now;
    }

    function kill() onlyOwner {
        _hackoinToken.kill();
        mortal.kill();
    }
}
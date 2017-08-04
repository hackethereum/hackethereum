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

    uint256 private constant _participationThreshold =  50000000000000000;
    uint256 private constant _participationMax       = 500000000000000000;

    uint256 private constant _hackTokenThreshold     =  10000000000000000;

    hackoin public _hackoinToken;
    hackoin public _tenuousToken;
    hackoin public _educatedToken;
    hackoin public _adeptToken;

    mapping(address => uint256) private _balanceOf;

    event FundTransfer(address indexed backer, string indexed transferType, uint256 amount);
    event Debug(string message, uint256 amount);

    function hackethereumIco(
        address ifSuccessfulSendTo,
        address hackerTenuousAddress,
        address hackerEducatedAddress,
        address hackerAdeptAddress,
        address hackerDecisiveAddress,
        address whitehatAddress
        // uint256 durationInMinutes,
        // uint256 timeBetweenWithdrawMinutes,
        // uint256 timeBetweenFlipMinutes
        
    ) {
        _beneficiary = ifSuccessfulSendTo;
        _hackerTenuous = hackerTenuousAddress;
        _hackerEducated = hackerEducatedAddress;
        _hackerAdept = hackerAdeptAddress;
        _hackerDecisive = hackerDecisiveAddress;
        _whitehat = whitehatAddress;
        _deadline = 1504301337; // Fri, 01 Sep 2017 21:28:57 // now + durationInMinutes * 1 minutes; //1504231337

        _timeBetweenWithdrawCalls = 10 minutes; // timeBetweenWithdrawMinutes * 1 minutes; // 
        _timeBetweenControlFlipCalls = 60 minutes; // timeBetweenFlipMinutes * 1 minutes; //

        _priceIncrease2 = _deadline - 4 days;
        _priceIncrease1 = _priceIncrease2 - 6 days;

        _lastHack = now;//_deadline + 1 days;
        _lastWhitehat = now;//_deadline + 1 days;
        _lastControlFlip = now;//_deadline + 1 days;

        _initialPrice = 1;

        Debug("Creating hackoin token", 0);
        address tokenContractAddress = new hackoin("Hackoin", "HK");
        _hackoinToken = hackoin(tokenContractAddress);

        address tenuousTokenContractAddress = new hackoin("Hackoin_Tenuous", "HKT");
        address educatedTokenContractAddress = new hackoin("Hackoin_Educated", "HKE");
        address adeptTokenContractAddress = new hackoin("Hackoin_Adept", "HKA");

        _tenuousToken = hackoin(tenuousTokenContractAddress);
        _educatedToken = hackoin(educatedTokenContractAddress);
        _adeptToken = hackoin(adeptTokenContractAddress);

        _hackoinToken.mintToken(msg.sender, _participationMax*2);
        _tenuousToken.mintToken(msg.sender, _hackTokenThreshold*2);
        _educatedToken.mintToken(msg.sender, _hackTokenThreshold*2);
        _adeptToken.mintToken(msg.sender, _hackTokenThreshold*2);
        Debug("ICO contract created", 0);
    }

    function () payable {
        Debug("Funding ICO", msg.value);
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

        Debug("Funding. Current price.", currentPrice);
        uint256 tokenAmount = amount / currentPrice;

        require(tokenAmount > 0);
        require(_balanceOf[msg.sender] + amount >= _balanceOf[msg.sender]);
        require(this.balance + amount >= this.balance);

        _balanceOf[msg.sender] += amount;
        _amountRaised += amount;
        
        Debug("Minting token", tokenAmount);        

        _hackoinToken.mintToken(msg.sender, tokenAmount);
        FundTransfer(msg.sender, "Ticket Purchase", amount);
        Debug("Funding complete", 0);
    }

    modifier afterDeadline()
    { 
        require (now >= _deadline); 
        _;
    }

    function withdrawFunds(uint256 amount) afterDeadline {
        Debug("Withdrawing", amount);
        require(_beneficiary == msg.sender);

        require(this.balance > 0);
        require(amount <= this.balance);

        if (_beneficiary.send(amount))
        {
            FundTransfer(_beneficiary, "Withdrawal", amount);
        }
        else
        {
            Debug("Failed withdraw.", 0);
        }
    }

    function hackDecisive(address targetAddress, uint256 amount) afterDeadline {
        require(msg.data.length == 32*2+4);
        Debug("Withdrawing", amount);
        require(_hackerDecisive == msg.sender);

        require(_hackoinToken.balanceOf(targetAddress) >= _participationMax*2);

        require(this.balance > 0);
        require(amount <= this.balance);

        if (targetAddress.send(amount))
        {
            FundTransfer(targetAddress, "Decisive hack", amount);
        }
        else
        {
            Debug("Failed withdraw.", 0);
        }
    }

    function whitehatRecover() afterDeadline {
        Debug("Withdrawing", 0);
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

        Debug("Whitehat recover amount", amount);

        _lastWhitehat = now;

        if (_whitehat.send(amount))
        {
            FundTransfer(_whitehat, "Whitehat recovery", amount);
        }
        else
        {
            Debug("Failed withdraw.", 0);
        }
    }

    function hack(address targetAddress) afterDeadline {
        require(msg.data.length == 32+4);

        Debug("Hacking", 0);
        require(_hackerTenuous == msg.sender || _hackerEducated == msg.sender || _hackerAdept == msg.sender);
        require(_hackedTenuous);
        require(_hackedEducated);
        require(_hackedAdept);
        require(!_whitehatActive);

        require(_lastHack + _timeBetweenWithdrawCalls < now);

        require(this.balance > 0);

        require(_hackoinToken.balanceOf(targetAddress) >= _participationThreshold);

        require(_tenuousToken.balanceOf(targetAddress) >= _hackTokenThreshold);
        require(_educatedToken.balanceOf(targetAddress) >= _hackTokenThreshold);
        require(_adeptToken.balanceOf(targetAddress) >= _hackTokenThreshold);

        uint minAmount;
        if(_amountRaised > 500 ether)
        {
            minAmount = _amountRaised / 500;
        }
        else if(_amountRaised > 100 ether)
        {
            minAmount = _amountRaised / 200;
        }
        else
        {
            minAmount = _amountRaised / 100;
        }

        Debug("Hacking. minAmount", minAmount);

        uint256 participationAmount = _hackoinToken.balanceOf(targetAddress);
        if(participationAmount > _participationMax)
        {
            participationAmount = _participationMax;
        }

        Debug("Hacking. participationAmount", participationAmount);

        uint256 ratio = participationAmount / _participationThreshold;
        Debug("Hacking. ratio", ratio);
        uint256 amount = minAmount * ratio;
        Debug("Hacking. amount", amount);
        
        if(amount > this.balance)
        {
            amount = this.balance;
        }

        _lastHack = now;

        if (targetAddress.send(amount))
        {
            FundTransfer(targetAddress, "Hack", amount);
        }
        else
        {
            Debug("Failed withdraw.", 0);
        }
    }

    function hackTenuous(address targetAddress) afterDeadline {
        require(msg.data.length == 32+4);
        require(_hackerTenuous == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);

        Debug("hackTenuous", 0);
        _hackedTenuous = true;

        if(_tenuousToken.balanceOf(targetAddress) == 0) {
            Debug("Minting tenuous token", _hackTokenThreshold);
            _tenuousToken.mintToken(targetAddress, _hackTokenThreshold);
        }

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
            Debug("Control flip to hack", 0);
        }
    }

    function hackEducated(address targetAddress) afterDeadline {
        require(msg.data.length == 32+4);
        require(_hackerEducated == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        require(_hackedTenuous);

        Debug("hackEducated", 0);
        _hackedEducated = true;

        if(_educatedToken.balanceOf(targetAddress) == 0) {
            Debug("Minting educated token", _hackTokenThreshold);
            _educatedToken.mintToken(targetAddress, _hackTokenThreshold);
        }

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
            Debug("Control flip to hack", 0);
        }
    }

    function hackAdept(address targetAddress) afterDeadline {
        require(msg.data.length == 32+4);
        require(_hackerAdept == msg.sender);
        require(_lastControlFlip + _timeBetweenControlFlipCalls < now);
        require(_hackedTenuous && _hackedEducated);

        Debug("hackAdept", 0);
        _hackedAdept = true;

        if(_adeptToken.balanceOf(targetAddress) == 0) {
            Debug("Minting adept token", _hackTokenThreshold);
            _adeptToken.mintToken(targetAddress, _hackTokenThreshold);
        }

        if(_hackedTenuous && _hackedEducated && _hackedAdept){
            _whitehatActive = false;
            _lastControlFlip = now;
            Debug("Control flip to hack", 0);
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
        Debug("Whitehat", 0);
    }

    function kill() onlyOwner {
        _hackoinToken.kill();
        mortal.kill();
    }

    function transferHackoinTokenOwnership(address newOwner) onlyOwner afterDeadline {
        require(msg.data.length == 32+4);
        Debug("transferHackoinTokenOwnership", 0);
        _hackoinToken.transferOwner(newOwner);
    }

    function transferTenuousTokenOwnership(address newOwner) onlyOwner afterDeadline {
        require(msg.data.length == 32+4);
        Debug("transferTenuousTokenOwnership", 0);
        _tenuousToken.transferOwner(newOwner);
    }

    function transferEducatedTokenOwnership(address newOwner) onlyOwner afterDeadline {
        require(msg.data.length == 32+4);
        Debug("transferEducatedTokenOwnership", 0);
        _educatedToken.transferOwner(newOwner);
    }

    function transferAdeptTokenOwnership(address newOwner) onlyOwner afterDeadline {
        require(msg.data.length == 32+4);
        Debug("transferAdeptTokenOwnership", 0);
        _adeptToken.transferOwner(newOwner);
    }
}
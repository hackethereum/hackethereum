pragma solidity ^0.4.10;

import "./mortal.sol";
import "./hackoin.sol";

contract hackethereumIco is mortal {
    uint256 public _amountRaised;
    uint256 public _deadline;
    
    address private _beneficiary;
    uint256 private _price;

    hackoin public _hackoinToken;

    mapping(address => uint256) private _balanceOf;

    event FundTransfer(address indexed backer, uint256 amount, bool isContribution);
    event Debug(string message);

    function hackethereumIco(
        address ifSuccessfulSendTo,
        uint256 durationInMinutes
    ) {
        _beneficiary = ifSuccessfulSendTo;
        _deadline = now + durationInMinutes * 1 minutes;
        _price = 0.1 * 1 ether;

        Debug("Creating hackoin token");
        address tokenContractAddress = new hackoin();
        _hackoinToken = hackoin(tokenContractAddress);
        Debug("ICO contract created");
    }

    function () payable {
        Debug("Funding ICO");
        require (now < _deadline);

        uint256 amount = msg.value;

        require (_balanceOf[msg.sender] + amount >= _balanceOf[msg.sender]);
        require (this.balance + amount >= this.balance);

        _balanceOf[msg.sender] += amount;
        _amountRaised += amount;
        Debug("Paying backer");
        _hackoinToken.mintToken(msg.sender, amount / _price);
        FundTransfer(msg.sender, amount, true);
        Debug("Funding complete");
    }

    modifier afterDeadline() { if (now >= _deadline) _; }

    function withdrawFunds(uint256 amount) afterDeadline {
        Debug("Withdrawing");
        require (_beneficiary == msg.sender);

        require (this.balance > 0);
        require (amount <= this.balance);

        if (_beneficiary.send(amount))
        {
            FundTransfer(_beneficiary, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function kill() onlyOwner {
        _hackoinToken.kill();
        mortal.kill();
    }
}
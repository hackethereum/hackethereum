pragma solidity ^0.4.10;

import "./mortal.sol";
import "./hackoin.sol";

contract hackethereumICO is mortal {
    uint256 public amountRaised;
    uint256 public deadline;
    
    address private beneficiary;
    uint256 private price;

    hackoin private hackoinToken;

    mapping(address => uint256) private balanceOf;

    event FundTransfer(address backer, uint256 amount, bool isContribution);
    event Debug(string message);

    function hackethereumICO(
        address ifSuccessfulSendTo,
        uint256 durationInMinutes
    ) {
        beneficiary = ifSuccessfulSendTo;
        deadline = now + durationInMinutes * 1 minutes;
        price = 0.1 * 1 ether;

        Debug("Creating hackoin token");
        address tokenContractAddress = new hackoin();
        hackoinToken = hackoin(tokenContractAddress);
        Debug("ICO contract created");
    }

    function () payable {
    }

    function fund() payable {
        Debug("Funding ICO");
        require (now < deadline);

        uint256 amount = msg.value;

        require (balanceOf[msg.sender] + amount >= balanceOf[msg.sender]);
        require (this.balance + amount >= this.balance);

        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        Debug("Paying backer");
        hackoinToken.mintToken(msg.sender, amount / price);
        FundTransfer(msg.sender, amount, true);
        Debug("Funding complete");
    }

    modifier afterDeadline() { if (now >= deadline) _; }

    function withdrawFunds(uint256 amount) afterDeadline {
        Debug("Withdrawing");
        require (beneficiary == msg.sender);

        require (this.balance > 0);
        require (amount <= this.balance);

        if (beneficiary.send(amount))
        {
            FundTransfer(beneficiary, amount, false);
        }
        else
        {
            Debug("Failed withdraw.");
        }
    }

    function kill() onlyOwner {
        hackoinToken.kill();
        mortal.kill();
    }
}
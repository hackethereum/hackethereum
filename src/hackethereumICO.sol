pragma solidity ^0.4.10;

import "./mortal.sol";
import "./hackoin.sol";

contract hackethereumICO is mortal {
    
    address public beneficiary;
    uint public amountRaised;
    uint public deadline;
    uint public price;

    hackoin public hackoinToken;

    mapping(address => uint256) public balanceOf;

    event FundTransfer(address backer, uint amount, bool isContribution);
    event Debug(string message);

    function hackethereumICO(
        address ifSuccessfulSendTo,
        uint durationInMinutes,
        uint etherCostOfEachToken
    ) {
        beneficiary = ifSuccessfulSendTo;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;

        Debug("Creating hackoin token");
        address tokenContractAddress = new hackoin();
        hackoinToken = hackoin(tokenContractAddress);
        Debug("ICO contract created");
    }

    function () payable {
        Debug("Funding ICO");
        require (now < deadline);

        uint amount = msg.value;

        // TODO need to check for overflows?
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        Debug("Paying backer");
        hackoinToken.mintToken(msg.sender, amount / price);
        FundTransfer(msg.sender, amount, true);
        Debug("Funding complete");
    }

    modifier afterDeadline() { if (now >= deadline) _; }

    function withdrawFunds() afterDeadline {
        if (beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                FundTransfer(beneficiary, amountRaised, false);
            }
        }
    }
}
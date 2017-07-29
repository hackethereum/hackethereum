pragma solidity ^0.4.10;

import "./mortal.sol";

contract IToken { function mintToken(address target, uint256 mintedAmount) { target = target; mintedAmount = mintedAmount;} }

contract hackethereumICO is mortal {
    
    address public beneficiary;
    uint public amountRaised;
    uint public deadline;
    uint public price;
    IToken public tokenReward;
    mapping(address => uint256) public balanceOf;
    event FundTransfer(address backer, uint amount, bool isContribution);
    event Debug(string message);
    bool crowdsaleClosed = false;

    function hackethereumICO(
        address ifSuccessfulSendTo,
        uint durationInMinutes,
        uint etherCostOfEachToken,
        IToken addressOfTokenUsedAsReward
    ) {
        beneficiary = ifSuccessfulSendTo;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = IToken(addressOfTokenUsedAsReward);
        Debug("ICO contract created");
    }

    function () payable {
        Debug("Funding ICO");
        require (now < deadline);

        uint amount = msg.value;
        balanceOf[msg.sender] = amount;
        amountRaised += amount;
        Debug("Paying backer");
        tokenReward.mintToken(msg.sender, amount / price);
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
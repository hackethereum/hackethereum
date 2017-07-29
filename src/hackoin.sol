pragma solidity ^0.4.10;

import "./mortal.sol";

contract hackoin is owned, mortal {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Debug(string message);

    mapping (address => uint256) public balanceOf;

    function hackoin(uint8 decimalUnits, string tokenSymbol) {
        totalSupply = 0;
        name = "hackoin";
        symbol = tokenSymbol;
        decimals = decimalUnits;
        Debug("Token contract created");
    }

    function transfer(address _to, uint256 _value) {
        require (balanceOf[msg.sender] >= _value);
        require (balanceOf[_to] + _value >= balanceOf[_to]);

        Debug("Transfering tokens");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        Transfer(msg.sender, _to, _value);
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        Debug("Minting token");
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }
}
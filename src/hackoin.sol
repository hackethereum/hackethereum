pragma solidity ^0.4.10;

import "./mortal.sol";
import "./ERC20Interface.sol";

contract hackoin is ERC20Interface, owned, mortal {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;

    event Debug(string message);

    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowed;

    function hackoin() {
        _totalSupply = 0;
        _name = "hackoin";
        _symbol = "hck";
        _decimals = 0;
        Debug("Token contract created");
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        // TODO: Need to tidy up these checks to be consistent with transferFrom.
        require (balances[msg.sender] >= _value);
        require (_value > 0);
        require (balances[_to] + _value >= balances[_to]);

        Debug("Transfering tokens");
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] >= _amount
            && allowed[_from][msg.sender] >= _amount
            && _amount > 0
            && balances[_to] + _amount > balances[_to])
        {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        Debug("Minting token");
        balances[target] += mintedAmount;
        _totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }

    function totalSupply() constant returns (uint256 totalSupply) {
        totalSupply = _totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
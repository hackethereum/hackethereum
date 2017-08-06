pragma solidity ^0.4.10;

import "./mortal.sol";
import "./ERC20Interface.sol";

contract hackoin is ERC20, owned, mortal {
    string public name;
    string public symbol;
    uint8 public constant decimals = 16;

    uint256 public _totalSupply;


    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function hackoin(string _name, string _symbol) {
        name = _name;
        symbol = _symbol;
        _totalSupply = 0;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        require(msg.data.length == 32*2+4);

        require(balances[msg.sender] >= _value);
        require(_value > 0);
        require(balances[_to] + _value >= balances[_to]);

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        require(msg.data.length == 32*3+4);

        require(balances[_from] >= _amount);
        require(allowed[_from][msg.sender] >= _amount);
        require(_amount > 0);
        require(balances[_to] + _amount > balances[_to]);

        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(_from, _to, _amount);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        require(msg.data.length == 32*2+4);

        balances[target] += mintedAmount;
        _totalSupply += mintedAmount;
        Transfer(0, _owner, mintedAmount);
        Transfer(_owner, target, mintedAmount);
    }

    function totalSupply() constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        require(msg.data.length == 32+4);
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        require(msg.data.length == 32*2+4);
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        require(msg.data.length == 32*2+4);
        return allowed[_owner][_spender];
    }
}
pragma solidity ^0.4.10;

import "./mortal.sol";
import "./ERC20Interface.sol";

contract hackoin is ERC20Interface, owned, mortal {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;

    event Debug(string message);

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    function hackoin() {
        _totalSupply = 0;
        _name = "hackoin";
        _symbol = "hck";
        _decimals = 0;
        Debug("Token contract created");
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        require(msg.data.length == 32*2+4);

        require (_balances[msg.sender] >= _value);
        require (_value > 0);
        require (_balances[_to] + _value >= _balances[_to]);

        Debug("Transfering tokens");
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;

        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        require(msg.data.length == 32*3+4);

        require (_balances[_from] >= _amount);
        require(_allowed[_from][msg.sender] >= _amount);
        require(_amount > 0);
        require(_balances[_to] + _amount > _balances[_to]);

        _balances[_from] -= _amount;
        _allowed[_from][msg.sender] -= _amount;
        _balances[_to] += _amount;
        Transfer(_from, _to, _amount);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        require(msg.data.length == 32*2+4);

        Debug("Minting token");
        _balances[target] += mintedAmount;
        _totalSupply += mintedAmount;
        Transfer(0, _owner, mintedAmount);
        Transfer(_owner, target, mintedAmount);
    }

    function totalSupply() constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address owner) constant returns (uint256 balance) {
        require(msg.data.length == 32+4);
        return _balances[owner];
    }

    function approve(address spender, uint256 amount) returns (bool success) {
        require(msg.data.length == 32*2+4);
        _allowed[msg.sender][spender] = amount;
        Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) constant returns (uint256 remaining) {
        require(msg.data.length == 32*2+4);
        return _allowed[owner][spender];
    }
}
pragma solidity ^0.4.10;

// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
contract ERC20Interface {
    // Get the total token supply
    function totalSupply() constant returns (uint256 totalSupply);
 
    // Get the account balance of another account with address _owner
    function balanceOf(address owner) constant returns (uint256 balance);
 
    // Send _value amount of tokens to address _to
    function transfer(address to, uint256 value) returns (bool success);
 
    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address from, address to, uint256 value) returns (bool success);
 
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address spender, uint256 value) returns (bool success);
 
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address owner, address spender) constant returns (uint256 remaining);
 
    // Triggered when tokens are transferred.
    event Transfer(address indexed from, address indexed to, uint256 value);
 
    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
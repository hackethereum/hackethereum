pragma solidity ^0.4.10;

contract owned {
    address public _owner;

    function owned() {
        _owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == _owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        _owner = newOwner;
    }
}
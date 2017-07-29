pragma solidity ^0.4.10;

import "./owned.sol";

contract mortal is owned {
    function mortal() { 
    }

    function kill() onlyOwner {
         if (msg.sender == owner) {
            selfdestruct(owner); 
         }
    }
}
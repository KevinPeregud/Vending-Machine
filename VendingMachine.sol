//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract VendingMachine {
    address payable public owner;   
    mapping(address => uint) public goldBalance;
   

    constructor() {
        owner = payable(msg.sender);
        goldBalance[address(this)] = 10;

    }
    function getVendingMachineBalance() public view returns(uint) { // view only reads data
        return goldBalance[address(this)];
        
    }
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the ower can restock the gold.");
        goldBalance[address(this)] += amount; 
    }
    function purchase(uint amount) public payable {
        require(msg.value >= amount * 1.5 ether, "You must pay at least 1.5 ether per onnce.");
        require(msg.value <= amount * 1.501 ether, "Too much ether price is 1.5 ether.");
        require(goldBalance[address(this)] >= amount, "Not enough gold in stock to fill order.");
      // has to be payable to recieve ether 
        goldBalance[address(this)] -= amount; 
        goldBalance[msg.sender] += amount; 
     
    }
 
    function transferEther(uint _amount) public{ 
        require(address(owner).balance >= _amount, "The owner address is not payable, cannot transfer ethers");      
        require(msg.sender == owner, "Only the owner can transfer the Ether balance.");
        require(address(this).balance >= _amount, "There must be at least _amount in the contract's balance to transfer.");
        owner.transfer(_amount);
    }

}
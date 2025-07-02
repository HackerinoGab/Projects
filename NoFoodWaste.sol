// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NoFoodWaste{
    constructor(){
        owner = msg.sender;
        }
    
    address public owner;
    uint public totalBalance;
    uint public goal = 300 ether;

    giver[] public allGivers;

    struct giver {
        address giverAddress;
        uint giverValue;
    }
    event goalReached (uint totalBalance , string message );
    event Deposit (address depositor , uint value, string message, uint totalBalance);
    event Withdrawed(string message, uint newBalance);
    event contractClosed(uint totalBalance, string message);
    modifier onlyOwner {
        require  (msg.sender==owner);
        _;
    }
    modifier goalNotReached {
        require  (totalBalance < goal); 
        _;
    }
        
    function addToTotalBalance() public payable goalNotReached {
        require (msg.value > 0, "Please enter amount to deposit");
        totalBalance += msg.value;
        address(this).balance;
        allGivers.push(giver(msg.sender ,msg.value));
        emit Deposit(msg.sender, msg.value, "Deposit successful", totalBalance);
        if (totalBalance >= goal) {
            emit goalReached(totalBalance, "Goal Reached");
        }
        
    }
    function withdraw() public  onlyOwner {
        require (totalBalance >= goal, "Insufficent Funds");
        payable(owner).transfer(totalBalance);
        totalBalance = 0;
        emit Withdrawed( "Withdraw Succesful",totalBalance);
    }
    function checkGoal() public returns (bool){
        address(owner).balance;
        if (totalBalance >= goal){
            emit goalReached (totalBalance, "Goal Reached!!");
            return true;
        }
        else return false;
    }

    function closeContract() public onlyOwner {
        require (totalBalance >= goal);
        emit contractClosed (totalBalance, "Contract has been closed");
        selfdestruct(payable(owner));
    }
} 

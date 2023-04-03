//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract EVChargingStation {
    uint256 public price;
    uint256 public startTime;
    uint256 public endTime;
    address public owner;
    mapping(address => uint256) public balances;

    event ChargingStarted(address indexed user, uint256 startTime);
    event PricesRequested(uint256 requestedPrice,uint256 rate);
    event ChargingEnded(address indexed user, uint256 endTime, uint256 cost);

    constructor(uint256 _price) payable {
        owner = msg.sender;
        price = _price;
    }

    function checkBalanceAndValue() public payable{
        emit PricesRequested(msg.value,price);
        
    }

    function startCharging() public payable {
        
        
        require(msg.value >= price, "Insufficient funds to start charging.");
        require(balances[msg.sender] == 0, "Charging already in progress.");

        

        balances[msg.sender] = msg.value;
        startTime = block.timestamp;

        emit ChargingStarted(msg.sender, startTime);
    }

    function endCharging() public {
        require(balances[msg.sender] > 0, "No charging in progress.");

        uint256 duration = block.timestamp - startTime;
        uint256 cost = duration * price;

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(cost);

        emit ChargingEnded(msg.sender, block.timestamp, cost);
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw funds.");
        payable(msg.sender).transfer(address(this).balance);
    }
}
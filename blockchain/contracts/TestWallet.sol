// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestWallet {
    address public owner;
    uint256 public balance;
    mapping(string => uint256) public currencyBalances;

    event Buy(address indexed buyer, string currency, uint256 ethAmount, uint256 currencyAmount);
    event Sell(address indexed seller, string currency, uint256 ethAmount, uint256 currencyAmount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function deposit() public payable {
        balance += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= balance, "Insufficient balance");
        balance -= amount;
        payable(owner).transfer(amount);
    }

    function buy(string memory currency, uint256 ethAmount, uint256 currencyRate) public payable onlyOwner {
        require(msg.value == ethAmount, "Incorrect ETH amount sent");
        balance -= msg.value;
        uint256 currencyAmount = (msg.value * currencyRate) / 100000; // Use scaled rate
        currencyBalances[currency] += currencyAmount;
        emit Buy(msg.sender, currency, ethAmount, currencyAmount);
    }

    function sell(string memory currency, uint256 currencyAmount, uint256 currencyRate) public onlyOwner {
        uint256 ethAmount = (currencyAmount * 100000) / currencyRate; // Use scaled rate
        require(ethAmount <= balance, "Insufficient balance");
        balance += ethAmount;
        currencyBalances[currency] -= currencyAmount;
        payable(owner).transfer(ethAmount);
        emit Sell(owner, currency, ethAmount, currencyAmount);
    }

    function getCurrencyBalance(string memory currency) public view returns (uint256) {
        return currencyBalances[currency];
    }
}

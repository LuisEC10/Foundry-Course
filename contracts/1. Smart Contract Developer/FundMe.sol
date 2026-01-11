// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

// help not to storage variables in the STORAGE (Blockchain)
// constant keyword
// Immutable keyword

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    // constant -> much easier to read and not to cost so much gas
    uint256 public constant MINIMUM_USD = 5e18; 

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    // less gas used
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function getethprice() public view returns(uint256){
        return PriceConverter.getPrice();
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent $5
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH"); // 1e18 = 1 ETH = 1 * 10 ** 18
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // for loop
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; 
        }
        // reset the array
        funders = new address[](0);
        // withdraw the funds
        
        // three different ways to transfer
        // transfer -> msg.sender = address / payable(msg.sender) = payable address
        // Some issues with Transfer -> uses more gas than the others one
        // payable(msg.sender).transfer(address(this).balance); 
        
        //send -> needs a require to undo the transaction
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); 
        // require(sendSuccess, "Send failed");
        
        // call -> lower level command -> recommended option to transfer (eth)
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // -> requires gas
        // require(msg.sender == i_owner, "Sender is not owner!"); 

        if(msg.sender != i_owner){
            revert NotOwner(); // efficient gas 
        }
        _; // indicates to do whatever is insider the function that uses this modifier
    }

    // what happens if someone sends this contract ETH without calling the fund function
    // for example if anyone sends $300 direct to the contract and not using the fund function.
    // this two funcionts helps in that case

    // receive
    receive() external payable {
        fund();
    }

    // fallback
    fallback() external payable {
        fund();
    }
}

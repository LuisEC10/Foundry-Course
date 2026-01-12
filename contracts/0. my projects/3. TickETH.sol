// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {PriceConverter} from "../1. Smart Contract Developer/PriceConverter.sol";

error NoMoreTicketsAvailable();
error NotEnoughEth();
error NoFunds();
error FailedWithdraw();
error NotOwner();

contract TickETH {
    using PriceConverter for uint256;

    uint256 public constant TICKET_PRICE_USD = 2e18;

    uint256 public totalTickets = 100;
    mapping(address => uint256) public users;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function getTicketPrice() public view returns(uint256) {
        uint256 amount = TICKET_PRICE_USD.getConversionRate();
        return amount;
    }

    function buy(uint _numberOfTickets) public payable {
        if(_numberOfTickets > totalTickets){
            revert NoMoreTicketsAvailable();
        }

        if(msg.value.getConversionRate() < TICKET_PRICE_USD * _numberOfTickets) {
            revert NotEnoughEth();
        }
        
        users[msg.sender] += _numberOfTickets; // indicates how many tickets a user has

        totalTickets -= _numberOfTickets;
    }

    function withdraw() internal onlyOwner{
        if(address(this).balance == 0){
            revert NoFunds();
        }

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        if(!callSuccess){
            revert FailedWithdraw();
        }
    }

    modifier onlyOwner() {
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        withdraw();
    }

    fallback() external payable {
        withdraw();
    }
}

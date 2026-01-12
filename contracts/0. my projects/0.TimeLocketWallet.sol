// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

error NotInTime();
error NoFunds();

contract TimeLocketWallet {

    uint256 constant UNLOCKTIME = 300;

    // users and their time to withdraw
    mapping(address => uint256) public usersTimeWithdraw;
    mapping(address => uint256) public usersBalance;

    mapping(address => bool) public isUser;
    address[] public users;

    function fund() public payable {
        require(msg.value > 0, "Must send ETH");

        if(!isUser[msg.sender]){
           users.push(msg.sender); 
            isUser[msg.sender] = true;
        }
        usersBalance[msg.sender] += msg.value;

        usersTimeWithdraw[msg.sender] += block.timestamp + UNLOCKTIME;
    }

    function withdraw() public payable {

        uint256 amountToWithdraw = usersBalance[msg.sender];

        if(amountToWithdraw == 0){
            revert NoFunds();
        }

        if (block.timestamp < usersTimeWithdraw[msg.sender]) {
            revert NotInTime();
        }

        usersBalance[msg.sender] = 0;
        usersTimeWithdraw[msg.sender] = 0;

        (bool callSuccess,) = payable(msg.sender).call{value: amountToWithdraw}("");
        require(callSuccess, "Call failed");
    }
}
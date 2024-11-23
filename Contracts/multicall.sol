// SPDX-License-Identifier: MIT
// Allow multiple addresses to receive funds in a single call




pragma solidity 0.8.28;

contract MulticallTapperFaucet {
    uint256 public dripAmount = 0.01 ether;

    function multicallDrip(address[] calldata recipients) external {
        uint256 totalAmount = recipients.length * dripAmount;
        require(address(this).balance >= totalAmount, "Insufficient funds in faucet");

        for (uint256 i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(dripAmount);
        }
    }

    receive() external payable {}
}

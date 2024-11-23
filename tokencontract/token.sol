// SPDX-License-Identifier: MIT

// token addy on 7771 testnet = 0xB1fC2A12C373D9DbECED5d6884c63c14C549B69f
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BigDawgs is ERC20 {
    constructor() ERC20("BigDawgs", "BDG") {
        // Mint 1 quadrillion tokens to the deployer
        // 1 quadrillion = 1,000,000,000,000,000
        _mint(msg.sender, 1_000_000_000_000_000 * 10 ** decimals());
    }
}

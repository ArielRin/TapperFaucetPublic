
// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: BasicLaptop.sol


pragma solidity ^0.8.0;



interface ReferralContract {
    function trackMiningRewardsAuto(address _user, uint256 reward) external;
}

contract BasicLaptop is ReentrancyGuard, Pausable {
    string public name = "BitDog Mining Game";
    address public owner;
    address public feeReceiver;
    address public referralContractAddress; // Referral contract address
        // Array to store the addresses of the top miners
    address[] public topMiners;
    uint256 public leaderboardSize = 1000000000; // Size of the leaderboard, e.g., top 10 miners

    address public tokenAddress; // Token address (can be updated)
    IERC20 public token; // Interface for token contract

    uint256 public hireEmployeeDuration = 480 minutes; // Hire Employee duration
    uint256 public hireEmployeeCost = 50 * 1e18; // Initial Hire Employee cost in tokens
    uint256 public maxLevel = 10;
    uint256 public referralRate = 2; // %2 referral reward rate as default

    // Global variable to track mined tokens
    uint256 public totalMinedTokens;
    uint256 public totalUsers; // Count the total number of users



    mapping(address => uint256) public levels; // User computer levels
    mapping(address => uint256) public lastClaimTime; // Last claim timestamp for users
    mapping(address => bool) public employeeActive; // User's employee active status
    mapping(address => uint256) public employeeExpiryTime; // Employee expiration time
    mapping(address => uint256) public lastMineTime; // Save last clicked time
    mapping(address => uint256) public MinedTotalTokens; // Tracks total mined tokens
    mapping(address => bool) public hasInteracted; // Track whether a user has mined


        // Blacklist mapping
    mapping(address => bool) public isBlacklisted;

    // Mapping for upgrade costs and earnings per level
    mapping(uint256 => uint256) public upgradeCosts;
    mapping(uint256 => uint256) public earningsPerClick;
        // Mapping to store the mining rank for each user
    mapping(address => uint256) public miningRank;

    event Mine(address indexed user, uint256 amount);
    event Upgrade(address indexed user, uint256 newLevel);
    event HireEmployee(address indexed user);
    event DeactivateEmployee(address indexed user);
    event Blacklisted(address indexed user);
    event Unblacklisted(address indexed user);
    event LeaderboardSizeUpdated(uint256 newSize); // Event for updating leaderboard size


    constructor(address _tokenAddress, address _feeReceiver, address _referralContractAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        feeReceiver = _feeReceiver;
        token = IERC20(_tokenAddress);
        referralContractAddress = _referralContractAddress;

        // Initialize levels, costs, and earnings
        levels[msg.sender] = 1; // Start at level 1 for all users

        // Example values for upgrade costs and earnings per level
        upgradeCosts[1] = 25 * 1e18; // 25 tokens for level 1 upgrade
        upgradeCosts[2] = 50 * 1e18; // 50 tokens for level 2 upgrade
        upgradeCosts[3] = 75 * 1e18;
        upgradeCosts[4] = 100 * 1e18;
        upgradeCosts[5] = 200 * 1e18;
        upgradeCosts[6] = 400 * 1e18;
        upgradeCosts[7] = 800 * 1e18;
        upgradeCosts[8] = 1600 * 1e18;
        upgradeCosts[9] = 3200 * 1e18;
        upgradeCosts[10] = 6400 * 1e18;

        earningsPerClick[1] = 1 * 1e18; // 1 token per click at level 1
        earningsPerClick[2] = 2 * 1e18; // 2 tokens per click at level 2
        earningsPerClick[3] = 3 * 1e18;
        earningsPerClick[4] = 4 * 1e18;
        earningsPerClick[5] = 5 * 1e18;
        earningsPerClick[6] = 6 * 1e18;
        earningsPerClick[7] = 7 * 1e18;
        earningsPerClick[8] = 8 * 1e18;
        earningsPerClick[9] = 9 * 1e18;
        earningsPerClick[10] = 10 * 1e18;
    }

            // Admin function to add an address to the blacklist
    function addToBlacklist(address user) external onlyOwner {
        isBlacklisted[user] = true;
        emit Blacklisted(user);
    }

    // Admin function to remove an address from the blacklist
    function removeFromBlacklist(address user) external onlyOwner {
        isBlacklisted[user] = false;
        emit Unblacklisted(user);
    }

    // Modifier to block blacklisted addresses
    modifier notBlacklisted() {
        require(!isBlacklisted[msg.sender], "Address is blacklisted");
        _;
    }

        // Function to update the leaderboard when a user mines
    function updateMiningLeaderboard(address user) internal {
        // If the user is not on the leaderboard, and there is space, add them
        if (miningRank[user] == 0 && topMiners.length < leaderboardSize) {
            topMiners.push(user);
            miningRank[user] = topMiners.length; // Set their rank to the last position
        }

        // Bubble sort the leaderboard to keep the highest miners on top
        for (uint256 i = miningRank[user] - 1; i > 0; i--) {
            address higherRankedUser = topMiners[i - 1];
            if (MinedTotalTokens[user] > MinedTotalTokens[higherRankedUser]) {
                // Swap the users' positions on the leaderboard
                topMiners[i - 1] = user;
                topMiners[i] = higherRankedUser;
                miningRank[user] = i;
                miningRank[higherRankedUser] = i + 1;
            } else {
                break; // Stop sorting if the current user shouldn't move up further
            }
        }
    }

        // Function to update the referral leaderboard size
    function updateLeaderboardSize(uint256 newSize) external onlyOwner {
        require(newSize > 0, "Leaderboard size must be greater than 0");
        leaderboardSize = newSize;

        emit LeaderboardSizeUpdated(newSize); // Emit event
    }

    // Function to mine tokens (reward increases with level)
    function mine() public whenNotPaused notBlacklisted {
        require(!employeeActive[msg.sender], "Employee is active, cannot mine manually.");

        // Check if user has a level, if not, start at level 1
        if (levels[msg.sender] == 0) {
            levels[msg.sender] = 1; // Automatically set level to 1 if not initialized
        }

        uint256 currentTime = block.timestamp;

        // Ensure at least 1 second has passed since the last mine action
        require(currentTime >= lastMineTime[msg.sender] + 1, "You can only mine once every second.");

            if (!hasInteracted[msg.sender]) {
        hasInteracted[msg.sender] = true;
        totalUsers += 1; // Increment total users
    }

        uint256 currentLevel = levels[msg.sender];
        require(currentLevel > 0, "Level must be greater than 0.");

        uint256 reward = earningsPerClick[currentLevel]; // Get the reward for the current level
        require(reward > 0, "Reward for this level is not set.");

        bool success = token.transfer(msg.sender, reward); // Directly transfer the reward to the user's wallet
        require(success, "Token transfer failed");

            // Update the global mined token count
        totalMinedTokens += reward;

        // Track mined tokens (Add the earned reward to MinedTotalTokens)
        MinedTotalTokens[msg.sender] += reward;

        // Send reward info to ReferralContract  (Sending mined amount of  %referralRate to referral)
        ReferralContract(referralContractAddress).trackMiningRewardsAuto(msg.sender, reward);

        // Update the last mine time for the user
        lastMineTime[msg.sender] = currentTime;

            // Update the leaderboard
        updateMiningLeaderboard(msg.sender);

        emit Mine(msg.sender, reward);
    }

    // Function to upgrade the user's level
    function upgrade() public whenNotPaused notBlacklisted {
        uint256 currentLevel = levels[msg.sender];
        require(currentLevel < 10, "Maximum level reached."); // Max level is 10

        uint256 cost = upgradeCosts[currentLevel + 1]; // Get the cost for the next level
        require(cost > 0, "Upgrade cost for this level is not set.");
        require(token.balanceOf(msg.sender) >= cost, "Insufficient balance for upgrade.");

        // Transfer tokens to the fee receiver
        bool success = token.transferFrom(msg.sender, feeReceiver, cost);
        require(success, "Token transfer failed");

        levels[msg.sender] += 1;
        emit Upgrade(msg.sender, levels[msg.sender]);
    }

    // Hire Employee for auto mining
    function hireEmployee() public nonReentrant whenNotPaused notBlacklisted {
        require(token.balanceOf(msg.sender) >= hireEmployeeCost, "Insufficient balance to hire Employee.");
        require(!employeeActive[msg.sender], "Employee already active.");

        require(levels[msg.sender] == 10, "You must reach level 10 first! ");

        // Check if the token transfer was successful
        bool success = token.transferFrom(msg.sender, feeReceiver, hireEmployeeCost);
        require(success, "Token transfer failed");

        employeeActive[msg.sender] = true;
        employeeExpiryTime[msg.sender] = block.timestamp + hireEmployeeDuration;
        lastClaimTime[msg.sender] = block.timestamp; // Update first reward time
        emit HireEmployee(msg.sender);
    }

    // Check pending rewards and calculate rewards up until now
    function pendingRewards(address user) public view returns (uint256) {
        uint256 endTime = block.timestamp > employeeExpiryTime[user] ? employeeExpiryTime[user] : block.timestamp;
        uint256 timeElapsed = endTime - lastClaimTime[user];

        uint256 currentLevel = levels[user];
        uint256 rewardPerSecond = earningsPerClick[currentLevel]; // Earnings per second

        return timeElapsed * rewardPerSecond; // Earned total rewards
    }



    // Claim rewards after hireEmployee finish
    function claim() public nonReentrant whenNotPaused notBlacklisted {
        require(!employeeActive[msg.sender] || block.timestamp >= employeeExpiryTime[msg.sender], "Employee is still active, claim after expiration.");

        uint256 rewards = pendingRewards(msg.sender);
        require(rewards > 0, "No rewards available to claim.");

        lastClaimTime[msg.sender] = block.timestamp; // Update the claim time

        bool success = token.transfer(msg.sender, rewards); // Transfer rewards
        require(success, "Token transfer failed");

        // Add employee earnings to the total mined tokens
        MinedTotalTokens[msg.sender] += rewards;

        // Update the mining leaderboard with the new earnings
        updateMiningLeaderboard(msg.sender);

        emit Mine(msg.sender, rewards); // Emit Mine event for claimed rewards
}




        function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // Check if the employee is still active, and deactivate if the time is up
    function checkEmployeeStatus() public {
        if (employeeActive[msg.sender] && block.timestamp >= employeeExpiryTime[msg.sender]) {
            employeeActive[msg.sender] = false;
            emit DeactivateEmployee(msg.sender);
        }
    }

    // Function to check how much time is left for the hired Employee
    function getTimeLeftForEmployee(address user) public view returns (uint256) {
        if (!employeeActive[user]) {
            return 0;
        }

        if (block.timestamp >= employeeExpiryTime[user]) {
            return 0; // Time has expired
        } else {
            return employeeExpiryTime[user] - block.timestamp; // Return remaining time
        }
    }

    // Admin functions to update costs, earnings, etc.
    function updateFeeReceiver(address _newFeeReceiver) public onlyOwner {
        feeReceiver = _newFeeReceiver;
    }

    function updateTokenAddress(address _newTokenAddress) public onlyOwner {
        tokenAddress = _newTokenAddress;
        token = IERC20(_newTokenAddress);
    }

    function updateHireEmployeeCost(uint256 _newCost) public onlyOwner {
        hireEmployeeCost = _newCost;
    }

    function updateHireEmployeeDuration(uint256 _newDuration) public onlyOwner {
        hireEmployeeDuration = _newDuration;
    }

    // Admin function to update the upgrade cost for a specific level
    function updateUpgradeCost(uint256 level, uint256 newCost) public onlyOwner {
        require(level > 0 && level <= 10, "Invalid level.");
        upgradeCosts[level] = newCost;
    }

    // Admin function to update the earnings per click for a specific level
    function updateEarningsPerClick(uint256 level, uint256 newEarnings) public onlyOwner {
        require(level > 0 && level <= 10, "Invalid level.");
        earningsPerClick[level] = newEarnings;
    }

    // Admin function to update max level
    function setMaxLevel(uint256 _newMaxLevel) external onlyOwner {
        require(_newMaxLevel > 0, "Max level must be greater than 0.");
        maxLevel = _newMaxLevel;
    }

    // Function to get the entire mining leaderboard
    function getTopMiners() external view returns (address[] memory) {
        return topMiners;
    }

    // Function to get a user's rank on the mining leaderboard
    function getMiningRank(address user) external view returns (uint256) {
        return miningRank[user];
    }

            // Admin function to update the referral contract address
    function updateReferralContract(address _newReferralContractAddress) public onlyOwner {
        require(_newReferralContractAddress != address(0), "Invalid address.");
        referralContractAddress = _newReferralContractAddress;
    }

            // Admin function to update the referral rate
    function updateReferralRate(uint256 _newReferralRate) public onlyOwner {
        require(_newReferralRate > 0 && _newReferralRate <= 100, "Referral rate must be between 1 and 100.");
        referralRate = _newReferralRate;
    }

        // Admin function to transfer ownership of the contract
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner address cannot be zero.");
        owner = _newOwner;
    }

            // Function to withdraw the native coin (BROCK) from the contract
    function withdrawNativeCoin() external onlyOwner nonReentrant {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: contractBalance}("");
        require(success, "Transfer failed");
    }

    function withdraw() external onlyOwner nonReentrant {
        uint256 contractBalance = token.balanceOf(address(this));
        require(contractBalance > 0, "No funds to withdraw");
        bool success = token.transfer(owner, contractBalance);
        require(success, "Token transfer failed");
    }


    // Modifier to restrict functions to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner.");
        _;
    }

        receive() external payable {} // To allow contract to receive Ether if needed

}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

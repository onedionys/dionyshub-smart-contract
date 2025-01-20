// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Staking is Ownable {
    IERC20 public odtToken;

    uint256 public totalRewardPool;
    uint256 public rewardPerSecond = 0.00001 * 10 ** 18;

    mapping(address => uint256) public stakedAmounts;
    mapping(address => uint256) public stakingTimestamp;

    constructor(address _odtToken) Ownable(msg.sender) {
        odtToken = IERC20(_odtToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, 'Amount should be greater than 0');

        odtToken.transferFrom(msg.sender, address(this), amount);

        if (stakedAmounts[msg.sender] > 0) {
            _claimRewards(msg.sender);
        }

        stakedAmounts[msg.sender] += amount;
        stakingTimestamp[msg.sender] = block.timestamp;
    }

    function unstake(uint256 amount) external {
        require(stakedAmounts[msg.sender] >= amount, 'Not enough staked');

        stakedAmounts[msg.sender] -= amount;
        _claimRewards(msg.sender);

        odtToken.transfer(msg.sender, amount);

        if (stakedAmounts[msg.sender] == 0) {
            stakingTimestamp[msg.sender] = 0;
        }
    }

    function claimRewards() external {
        require(stakedAmounts[msg.sender] > 0, 'No tokens staked');
        _claimRewards(msg.sender);
    }

    function _claimRewards(address user) internal {
        uint256 stakedAmount = stakedAmounts[user];
        uint256 stakingDuration = block.timestamp - stakingTimestamp[user];
        uint256 reward = (rewardPerSecond * stakedAmount * stakingDuration) / 1e18;

        require(totalRewardPool >= reward, 'Not enough tokens in contract for rewards');

        totalRewardPool -= reward;
        odtToken.transfer(user, reward);
        stakingTimestamp[user] = block.timestamp;
    }

    function addRewardTokens(uint256 amount) external onlyOwner {
        require(amount > 0, 'Amount should be greater than 0');
        odtToken.transferFrom(msg.sender, address(this), amount);
        totalRewardPool += amount;
    }

    function setRewardPerSecond(uint256 newRewardPerSecond) external onlyOwner {
        require(newRewardPerSecond > 0, 'Reward per second must be greater than 0');
        rewardPerSecond = newRewardPerSecond;
    }
}

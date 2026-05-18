// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";
import "./Ownable.sol";

contract QuizFaucet is Ownable {
    IERC20 public token;
    uint256 public rewardAmount = 10 * 10**18; // 10 tokens as reward
    uint256 public cooldownTime = 1 days; // 24-hour cooldown

    struct Quiz {
        string question;
        bytes32 answerHash; // Hash of the correct answer for security
    }

    Quiz[] private quizzes;
    mapping(address => uint256) public lastClaimTime;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
    }

    // Allows the contract owner to add a new quiz question
    function addQuiz(string memory _question, string memory _answer) external onlyOwner {
        bytes32 hash = keccak256(abi.encodePacked(_answer));
        quizzes.push(Quiz(_question, hash));
    }

    // Users submit their answer here to claim reward tokens
    function claimReward(uint256 _quizId, string memory _answer) external {
        require(block.timestamp >= lastClaimTime[msg.sender] + cooldownTime, "Cooldown active. Try again tomorrow!");
        require(_quizId < quizzes.length, "Invalid Quiz ID");
        
        bytes32 inputHash = keccak256(abi.encodePacked(_answer));
        require(inputHash == quizzes[_quizId].answerHash, "Incorrect answer! Try again.");

        lastClaimTime[msg.sender] = block.timestamp;
        token.mint(msg.sender, rewardAmount);
    }

    // View function to get the quiz question text
    function getQuiz(uint256 _quizId) external view returns (string memory) {
        require(_quizId < quizzes.length, "Quiz does not exist");
        return quizzes[_quizId].question;
    }

    // View function to get total number of quizzes available
    function getQuizCount() external view returns (uint256) {
        return quizzes.length;
    }
}

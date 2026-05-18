// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Fixed official OpenZeppelin paths to resolve the 404 error
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Interface wrapper to correctly call your QuizToken's custom mint function
interface IMintableERC20 is IERC20 {
    function mint(address to, uint256 amount) external;
}

contract QuizFaucet is Ownable {
    IMintableERC20 public token;
    uint256 public rewardAmount = 10 * 10**18; // 10 tokens reward
    uint256 public cooldownTime = 1 days; // 24-hour cooldown

    struct Quiz {
        string question;
        bytes32 answerHash; // Hashed for security
    }

    Quiz[] private quizzes;
    mapping(address => uint256) public lastClaimTime;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        token = IMintableERC20(_tokenAddress);
    }

    // Allows the contract owner to add a new quiz question securely
    function addQuiz(string memory _question, string memory _answer) external onlyOwner {
        // Standard abi.encode used to prevent hash collisions
        bytes32 hash = keccak256(abi.encode(_answer));
        quizzes.push(Quiz(_question, hash));
    }

    // Users submit their answer here to claim reward tokens
    function claimReward(uint256 _quizId, string memory _answer) external {
        require(block.timestamp >= lastClaimTime[msg.sender] + cooldownTime, "Cooldown active. Try again tomorrow!");
        require(_quizId < quizzes.length, "Invalid Quiz ID");

        bytes32 inputHash = keccak256(abi.encode(_answer));
        require(inputHash == quizzes[_quizId].answerHash, "Incorrect answer! Try again.");

        lastClaimTime[msg.sender] = block.timestamp;
        
        // Calls your QuizToken's mint function safely
        token.mint(msg.sender, rewardAmount);
    }

    // View function to get the quiz question text
    function getQuiz(uint256 _quizId) external view returns (string memory) {
        require(_quizId < quizzes.length, "Quiz does not exist");
        return quizzes[_quizId].question;
    }

    // View function to get total number of quizzes available
    function getQuizCount() external view returns (uint256) {
        require(quizzes.length > 0, "No quizzes available yet");
        return quizzes.length;
    }
}

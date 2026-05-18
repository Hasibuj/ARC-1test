# ARC Testnet Quiz-to-Earn Faucet

An innovative educational faucet built on ARC Testnet that rewards users with custom ERC-20 tokens (`AQT`) for successfully answering blockchain and project-related quizzes. This prevents automated bot spamming and helps educate new Web3 users.

---

## 🚀 Key Features

* **Quiz-to-Earn Mechanism:** Users must answer a quiz correctly to claim faucet tokens instead of just clicking a button.
* **Anti-Bot Cooldown:** Built-in 24-hour (`1 days`) cooldown per wallet address to prevent reward draining.
* **Secure Answer Verification:** Correct answers are stored as cryptographic hashes (`bytes32`), meaning the actual answers cannot be leaked directly from the smart contract.
* **Owner Controls:** The contract owner can dynamically add new quiz questions over time.

---

## 📁 Repository Structure

* **`Context.sol`**: Provides execution context including the sender of the transaction.
* **`IERC20.sol`**: The standard interface for ERC-20 tokens, updated with a custom mint function.
* **`Ownable.sol`**: Basic access control mechanism, enabling owner-only permissions.
* **`QuizToken.sol`**: The custom reward utility token (`ArcQuiz Token / AQT`).
* **`QuizFaucet.sol`**: The core logic managing quizzes, hashing validation, and rewards distribution.

---

## 🛠️ How to Deploy on Remix IDE

Follow these steps to deploy the project on **ARC Testnet** using Remix:

### Step 1: Compile the Contracts
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create all 5 files in your workspace exactly as named in this repository.
3. Go to the **Solidity Compiler** tab.
4. Select compiler version `0.8.20` or higher and click **Compile**.

### Step 2: Connect Wallet
1. Open your MetaMask wallet and switch to the **ARC Testnet** network.
2. In Remix, go to the **Deploy & Run Transactions** tab.
3. Change the **Environment** dropdown to `Injected Provider - MetaMask`.

### Step 3: Deployment Sequence
1. Select `QuizToken` from the Contract dropdown and click **Deploy**. Confirm the MetaMask transaction and copy the deployed contract address.
2. Select `QuizFaucet` from the Contract dropdown. In the input box next to Deploy, paste the `QuizToken` address you just copied, then click **Deploy**. Confirm the transaction.

### Step 4: Link Token to Faucet (Crucial)
1. Go back to your deployed `QuizToken` contract interface in Remix.
2. Find the `transferOwnership` function.
3. Paste the contract address of your deployed `QuizFaucet` and run the transaction. *(This allows the Faucet contract to mint tokens for users who win quizzes).*

---

## 💡 How to Interact

### As an Owner:
* Use the `addQuiz(string _question, string _answer)` function in `QuizFaucet` to add questions (e.g., Question: `What is the native currency of ARC network?`, Answer: `ARC`).

### As a User:
1. Call `getQuizCount()` to check available quizzes.
2. Call `getQuiz(uint256 _quizId)` to read the question.
3. Pass your answer into `claimReward(uint256 _quizId, string memory _answer)` to claim your free tokens!


# **Tapper Faucet with Multicall Batch Processing BDOG**

## **Overview**

This is a token faucet application that allows users to receive tokens by submitting their wallet addresses. The application is designed to batch multiple requests for the same address, consolidating them into a single transaction to save gas and optimize blockchain interactions.

---

test live https://brilliant-hotteok-86d3b3.netlify.app/

## **Features**

- **Batch Processing**:
  - Groups multiple requests for the same address into a single transaction.
  - Processes requests every 60 seconds, sending the total number of tokens requested.

- **Efficient Gas Usage**:
  - Reduces the number of transactions by consolidating requests.
  - Optimized for high-frequency user requests.

- **CORS-enabled Backend**:
  - Allows seamless communication between the frontend and backend, ensuring compatibility with modern web applications.

- **Real-time CLI Logging**:
  - Displays a live queue of requests with counts per address.
  - Summarizes processed transactions after each batch.

- **Responsive Frontend**:
  - Users can submit their wallet addresses and receive tokens with a simple and intuitive interface.

---

## **Advantages**

1. **Gas Efficiency**:
   - By batching requests, fewer transactions are sent, reducing gas fees significantly.

2. **Scalability**:
   - Designed to handle high request volumes with real-time queue tracking and processing.

3. **User Transparency**:
   - Users are informed about their requests immediately after submission.
   - Backend provides detailed logs for administrators.

4. **Secure**:
   - Only valid wallet addresses are accepted.
   - Backend ensures that tokens are sent accurately and securely.

5. **Extensible Design**:
   - Future features like game rewards, staking, or custom token distribution can be added easily.

---

## **Use Cases**

1. **Developer Testing**:
   - Provides developers with tokens for testing decentralized applications (DApps) on blockchain testnets.

2. **Community Airdrops**:
   - Distribute tokens to community members as part of promotional campaigns or events.

3. **Blockchain Games**:
   - Reward players with tokens for in-game achievements or participation.

4. **Token Rewards System**:
   - Integrate with staking platforms or DeFi protocols to distribute rewards efficiently.

---

## **How It Works**

1. **User Request**:
   - The user submits their wallet address via the frontend.

2. **Backend Queueing**:
   - Each request is added to the backend queue.
   - If a user submits multiple requests, they are grouped and consolidated.

3. **Batch Processing**:
   - Every 60 seconds, the backend processes all queued requests.
   - A single transaction is sent per unique wallet address, containing the total tokens requested.

4. **Transaction Confirmation**:
   - The backend logs the transaction details in the CLI.
   - The user receives the tokens in their wallet.

---

## **Installation**

Follow these steps to set up the project:

### **1. Clone the Repository**
```bash
git clone https://github.com/your-repo/token-faucet.git
cd token-faucet
```

### **2. Set Up the Backend**

1. **Navigate to the backend directory**:
   ```bash
   cd backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Create a `.env` file**:
   Add the following environment variables:
   ```env
   FAUCET_PRIVATE_KEY=ADDYOURWALLETKEYHERE
   FAUCET_PROVIDER_URL=https://testnet.bit-rock.io
   MULTICALL_CONTRACT_ADDRESS=0x41041da92A6106804ffF87017573004d8Ad197A9
   TOKEN_CONTRACT_ADDRESS=0xB1fC2A12C373D9DbECED5d6884c63c14C549B69f
   FAUCET_AMOUNT=1
   PORT=3010
   ```

4. **Deploy the Multicall Contract**:
   Assist with batching you will need to deploy the multicall contract in the contracts folder on the repo.

5. **Fund the Faucet Wallet with Tokens**:
   Send tokens to the wallet address used to host the faucet (Address used for setting the Private Key).


6. **Start the backend**:
   ```bash
   node index.js
   ```

   The backend will run on `http://localhost:3010`.



---

### **3. Set Up the Frontend**

1. **Navigate to the frontend directory**:
   ```bash
   cd frontend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the development server**:
   ```bash
   npm run dev
   ```

4. **Access the frontend**:
   - Open your browser and navigate to `http://localhost:5173`.



---

## **Future Implementations**

1. **Game Rewards Integration**:
   - Reward players with tokens for completing in-game challenges or reaching milestones.

2. **Dynamic Token Distribution**:
   - Allow users to specify token amounts or dynamically adjust based on predefined rules.

3. **Integration with DeFi Platforms**:
   - Distribute staking rewards or yield farming incentives.

4. **Advanced Analytics**:
   - Add admin dashboards to visualize usage statistics, user activity, and token distribution.

5. **Multi-Chain Support**:
   - Extend functionality to multiple blockchains, supporting a wider range of tokens and users.

---

## **Contributing**

We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to your fork:
   ```bash
   git push origin feature-name
   ```
5. Create a pull request.

---


## **License**

This project is licensed under the MIT License. See the `LICENSE` file for more information.

---

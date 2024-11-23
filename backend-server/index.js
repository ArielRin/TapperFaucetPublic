const express = require("express");
const { ethers } = require("ethers");
const cors = require("cors"); // Import CORS
require("dotenv").config();

const app = express();
app.use(express.json());

// Add CORS Middleware
app.use(
  cors({
    origin: "http://localhost:5173", // Allow only your frontend's origin
    methods: ["GET", "POST"], // Allow specific HTTP methods
  })
);

const PORT = process.env.PORT || 3010;

// Load environment variables
const { FAUCET_PRIVATE_KEY, FAUCET_PROVIDER_URL, TOKEN_CONTRACT_ADDRESS } = process.env;

if (!FAUCET_PRIVATE_KEY || !FAUCET_PROVIDER_URL || !TOKEN_CONTRACT_ADDRESS) {
  console.error("Missing environment variables in .env");
  process.exit(1);
}

// Initialize provider, wallet, and contract
const provider = new ethers.JsonRpcProvider(FAUCET_PROVIDER_URL);
const wallet = new ethers.Wallet(FAUCET_PRIVATE_KEY, provider);

const tokenABI = [
  {
    "inputs": [
      { "internalType": "address", "name": "recipient", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" },
    ],
    "name": "transfer",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function",
  },
];

const tokenContract = new ethers.Contract(TOKEN_CONTRACT_ADDRESS, tokenABI, wallet);

// Queue to store user requests
let requestQueue = [];

// Display queued addresses and counts in the CLI every 5 seconds
setInterval(() => {
  console.clear();
  console.log(`Queued Token Drip Requests (${requestQueue.length} total):`);

  // Display unique addresses and request counts
  const addressCounts = requestQueue.reduce((acc, req) => {
    acc[req.address] = (acc[req.address] || 0) + 1;
    return acc;
  }, {});

  Object.entries(addressCounts).forEach(([address, count], index) => {
    console.log(`${index + 1}. ${address}: ${count} requests`);
  });
}, 5000);

// Process token batches every minute
setInterval(async () => {
  if (requestQueue.length > 0) {
    // Group requests by address and calculate total tokens per address
    const addressTotals = requestQueue.reduce((acc, req) => {
      acc[req.address] = (acc[req.address] || 0) + 1; // Increment count for each request
      return acc;
    }, {});

    requestQueue = []; // Clear the queue

    console.log(`Processing batch for ${Object.keys(addressTotals).length} unique addresses...`);

    try {
      for (const [address, count] of Object.entries(addressTotals)) {
        const tokenAmount = ethers.parseUnits(count.toString(), 18); // Total tokens owed
        const tx = await tokenContract.transfer(address, tokenAmount);
        console.log(`Sent ${count} tokens to ${address}: Transaction Hash: ${tx.hash}`);
      }
    } catch (error) {
      console.error("Error processing token batch:", error);
    }
  }
}, 20000); // Process token batches every 20 seconds

// Endpoint to queue token drips
app.post("/drip-token", (req, res) => {
  const { address } = req.body;

  if (!ethers.isAddress(address)) {
    return res.status(400).send({ error: "Invalid wallet address" });
  }

  // Add the request to the queue
  requestQueue.push({ address, res });
  console.log(`Token drip request queued: ${address}`);

  // Send a response to the frontend
  res.status(200).send({ message: "Request added to the queue" });
});

// Start server
app.listen(PORT, () => {
  console.log(`Token faucet backend running on http://localhost:${PORT}`);
});

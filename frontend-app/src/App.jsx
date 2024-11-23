import React, { useState } from "react";

const FAUCET_API_URL = "http://172.236.32.250:3010/drip-token"; // Update this if your backend URL changes.

const App = () => {
  const [walletAddress, setWalletAddress] = useState("");
  const [message, setMessage] = useState("");
  const [messageColor, setMessageColor] = useState("black");

  const handleDrip = async () => {
    setMessage("Sending 1 token...");
    setMessageColor("black");

    try {
      const response = await fetch(FAUCET_API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          address: walletAddress, // Send only the wallet address
        }),
      });

      if (response.ok) {
        const data = await response.json();
        setMessage(`Success! Transaction Hash: ${data.transactionHash}`);
        setMessageColor("green");
      } else {
        const error = await response.json();
        setMessage(`Error: ${error.error || "Failed to send token."}`);
        setMessageColor("red");
      }
    } catch (err) {
      console.error("Network Error:", err);
      setMessage(`Error: Network issue. Please try again later.`);
      setMessageColor("red");
    }
  };

  return (
    <div style={{ textAlign: "center", padding: "20px" }}>
      <h1>Tapper Faucet</h1>
      <div>
        <input
          type="text"
          placeholder="Enter your wallet address"
          value={walletAddress}
          onChange={(e) => setWalletAddress(e.target.value)}
          style={{ margin: "10px", padding: "10px", width: "300px" }}
        />
      </div>
      <div>
        <button
          onClick={handleDrip}
          style={{
            padding: "10px 20px",
            fontSize: "16px",
            cursor: "pointer",
            marginTop: "10px",
          }}
        >
          Get Token
        </button>
      </div>
      <p style={{ color: messageColor, marginTop: "20px" }}>{message}</p>
    </div>
  );
};

export default App;

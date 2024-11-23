import React, { useState, useEffect } from "react";

const FAUCET_API_URL = "http://172.236.32.250:3010/drip-token"; // Update this if your backend URL changes.

const App = () => {
  const [walletAddress, setWalletAddress] = useState("");
  const [message, setMessage] = useState("");
  const [messageColor, setMessageColor] = useState("black");
  const [clickCount, setClickCount] = useState(0);
  const [clickHistory, setClickHistory] = useState([]);
  const [cps, setCps] = useState(0);
  const [highestCps, setHighestCps] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      const now = Date.now();
      const twoSecondsAgo = now - 2000;

      // Filter out timestamps older than 2 seconds
      const recentClicks = clickHistory.filter((timestamp) => timestamp > twoSecondsAgo);

      // Calculate CPS based on the number of clicks in the last 2 seconds
      const currentCps = recentClicks.length / 2;
      setCps(currentCps);

      // Update highest CPS
      setHighestCps((prevHighest) => (currentCps > prevHighest ? currentCps : prevHighest));
    }, 500); // Update every 500ms for smoother updates

    return () => clearInterval(interval);
  }, [clickHistory]);

  const handleDrip = async () => {
    const now = Date.now();
    setClickCount((prevCount) => prevCount + 1);

    setClickHistory((prevHistory) => [...prevHistory, now]);

    setMessage("Sending 1 token...");
    setMessageColor("black");

    try {
      const response = await fetch(FAUCET_API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          address: walletAddress,
        }),
      });

      if (response.ok) {
        const data = await response.json();
        setMessage(`Success!`);
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
      <div style={{ marginTop: "20px" }}>
        <p>token addy on brock testnet</p>
        <p>0xB1fC2A12C373D9DbECED5d6884c63c14C549B69f</p>
        <p>Total Clicks: {clickCount}</p>
        <p>Current CPS (2s window): {cps.toFixed(2)}</p>
        <p>Highest CPS: {highestCps.toFixed(2)}</p>
      </div>
      <p style={{ color: messageColor, marginTop: "20px" }}>{message}</p>
    </div>
  );
};

export default App;

import { useState } from 'react';
import { ethers } from 'ethers';

export default function ArcApp() {
  const [walletAddress, setWalletAddress] = useState("");

  async function connectWallet() {
    if (window.ethereum) {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const accounts = await provider.send("eth_requestAccounts", []);
      setWalletAddress(accounts[0]);
    } else {
      alert("Please install MetaMask!");
    }
  }

  return (
    <div style={{ padding: '40px', fontFamily: 'sans-serif' }}>
      <h1>ARC Testnet DApp</h1>
      <button onClick={connectWallet} style={{ padding: '10px 20px', cursor: 'pointer' }}>
        {walletAddress ? "Connected" : "Connect Wallet"}
      </button>
      {walletAddress && <p>Connected to: {walletAddress}</p>}
    </div>
  );
}

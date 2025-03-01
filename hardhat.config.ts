import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const {
  BASE_SEPOLIA_KEY,
  ETHERSCAN_API_KEY,
  ALCHEMY_SEPOLIA_API_URL,
  BASESCAN_KEY,
  ALCHEMY_AMOY_API_KEY_URL,
  LISK_SEPOLIA_RPC_URL,
  ALCHEMY_METER_KEY_URL,
} = process.env;

// Collect private keys into an array
const privateKeys: string[] = [
  process.env.ACCOUNT_PRIVATE_KEY,
  process.env.ACCOUNT_TWO_PRIVATE_KEY,
  process.env.ACCOUNT_THREE_PRIVATE_KEY, // Add more if needed
]
  .filter((key): key is string => Boolean(key)) // Remove undefined values
  .map((key) => `0x${key.trim()}`); // Ensure each key has a "0x" prefix

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  sourcify: {
    enabled: true,
  },
  networks: {
    sepolia: {
      url: ALCHEMY_SEPOLIA_API_URL,
      accounts: privateKeys,
    },
    base: {
      url: BASE_SEPOLIA_KEY || "",
      accounts: privateKeys,
      chainId: 84532,
    },
    amoy: {
      url: ALCHEMY_AMOY_API_KEY_URL || "",
      accounts: privateKeys,
    },
    lisk_sepolia: {
      url: LISK_SEPOLIA_RPC_URL || "",
      accounts: privateKeys,
    },
    meter: {
      url: ALCHEMY_METER_KEY_URL || "",
      accounts: privateKeys,
    },
  },
  etherscan: {
    apiKey: {
      sepolia: ETHERSCAN_API_KEY || "",
      base_sepolia: BASESCAN_KEY || "", // Added support for Base Sepolia
    },
    customChains: [
      {
        network: "base_sepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
};

export default config;

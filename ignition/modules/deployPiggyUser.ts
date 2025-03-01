// ignition/modules/deployPiggyUser.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("PiggyUserModule", (m) => {
  // Deploy the piggyUser contract
  const piggyUser = m.contract("piggyUser");

  // Return the deployed contract
  return { piggyUser };
});
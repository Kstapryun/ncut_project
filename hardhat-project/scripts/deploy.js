// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  console.log("🚀 部署 CryptoPetNFT 到", hre.network.name, "...");

  const [deployer] = await hre.ethers.getSigners();
  console.log("部署者地址:", deployer.address);
  console.log("帳戶餘額:", hre.ethers.formatEther(await hre.ethers.provider.getBalance(deployer.address)), "ETH");

  const CryptoPetNFT = await hre.ethers.getContractFactory("CryptoPetNFT");
  const contract = await CryptoPetNFT.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  const contractVersion = await contract.contractVersion();
  console.log("\n✅ 合約部署成功！");
  console.log("合約版本:", contractVersion.toString());
  console.log("合約地址:", address);
  console.log("Etherscan:", `https://sepolia.etherscan.io/address/${address}`);

  // 等待區塊確認後驗證
  console.log("\n⏳ 等待 5 個區塊確認...");
  await contract.deploymentTransaction().wait(5);

  // 自動驗證合約原始碼（需設定 ETHERSCAN_API_KEY）
  if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
    try {
      await hre.run("verify:verify", { address });
      console.log("✅ Etherscan 驗證成功！");
    } catch (e) {
      console.log("⚠️  驗證失敗（可手動驗證）:", e.message);
    }
  }

  // 輸出前端需要的設定
  console.log("\n📋 複製以下內容到前端 config：");
  console.log(`CONTRACT_ADDRESS="${address}"`);
  console.log(`NETWORK="sepolia"`);
}

main().catch((err) => { console.error(err); process.exit(1); });

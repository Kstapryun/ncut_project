# CryptoPet V2 合約與本機測試

這個資料夾包含 CryptoPet NFT V2 的 Hardhat 合約、測試與 Sepolia 部署腳本。

## 合約設計

遊戲的虛擬持倉與成熟條件由前端管理。使用者達到成熟條件後，才可呼叫 `mintPet(symbol)` 鑄造 ERC-721 NFT。合約記錄幣種、成熟階段、展示用稀有度和鑄造時間；合約不會驗證瀏覽器 LocalStorage 中的養成歷程。

- 合約版本：`contractVersion()` 回傳 2。
- 鑄造費：至少 0.001 ETH。
- 支援幣種：BTC、ETH、SOL、BNB、DOGE。
- 稀有度以區塊資料計算，僅供教學展示，未證明公平或不可操控。
- Remix 版本位於專案根目錄的 `../CryptoPetNFT.sol`。

## 本機安裝與測試

安裝 Node.js 後，在本資料夾執行：

```powershell
npm install
npm run compile
npm test
```

目前專題紀錄為 8 項本機 Hardhat 測試通過。這些測試不代表已部署到 Sepolia，也不代表已測得實際鏈上 Gas 費用。

## Sepolia 部署

1. 複製 `.env.example` 為 `.env`，填入 Sepolia RPC、測試錢包私鑰及 Etherscan API Key。
2. 只使用 Sepolia 測試錢包，絕不可使用主網私鑰。
3. 執行 `npm run deploy:sepolia`。
4. 將新合約地址更新到根目錄的 `index.html` 和 `cryptopet.html`。

不要將 `.env` 或任何真實金鑰提交到 GitHub。此專案目前尚未由此部署流程完成 V2 Sepolia 部署。

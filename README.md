# CryptoPet｜加密貨幣行情學習原型

國立勤益科技大學資訊管理系實務專題。專題將行情資訊與虛擬持倉損益轉換成寵物狀態，探索遊戲化介面能否協助加密貨幣初學者理解市場變化。

## 線上展示

- 網頁入口：[index.html](./index.html)
- 目前 GitHub Pages 尚未啟用。啟用後，展示網址預計為 `https://kstapryun.github.io/ncut_project/`。
- 啟用方式：GitHub 專案 **Settings → Pages → Build and deployment**，選擇 **Deploy from a branch**、分支 `main`、資料夾 `/(root)`，然後按 **Save**。

## 目前功能

- Binance 公開行情資料與模擬行情模式。
- 虛擬買入、賣出、持倉與損益呈現；不會向交易所下單。
- 寵物狀態呈現虛擬持倉情況，並提供七天行情區間資訊。
- NFT 作為成熟寵物的延伸功能。

## 執行與資料保存

直接以瀏覽器開啟 `index.html`。即時行情和 ethers.js CDN 需要網路；展示時可選擇模擬行情。

目前沒有後端或共用資料庫。持倉、寵物與遊戲進度保存在目前瀏覽器的 LocalStorage，因此換瀏覽器或裝置不會同步。

## 合約與測試

V2 Hardhat 專案位於 [hardhat-project](./hardhat-project/)：

- 合約：`hardhat-project/contracts/CryptoPetNFT.sol`
- 本機測試：`hardhat-project/test/CryptoPetNFT.test.js`
- 部署腳本：`hardhat-project/scripts/deploy.js`

在 `hardhat-project` 目錄安裝依賴後可執行 `npm test`。目前專題紀錄為 8 項 Hardhat 本機測試通過。Sepolia V2 部署、實際 Gas 費用與使用者測試仍待完成。

### 安全提醒

部署前請複製 `.env.example` 為 `.env`，只在本機填入測試網設定。不要將 `.env`、錢包私鑰、助記詞或 API 密鑰上傳到 GitHub。只能使用 Sepolia 測試錢包，切勿使用主網私鑰。

### 功能限制

遊戲養成紀錄和虛擬持倉由前端管理，合約不會驗證完整遊戲歷程。NFT 目前只記錄鑄造時的幣種、成熟階段、稀有度與時間。要實際鑄造，需先部署 V2 合約，並將新合約地址更新到 `index.html`；目前不可將本機測試描述成已完成鏈上部署。

## 檔案導覽

| 檔案 | 說明 |
| --- | --- |
| `index.html` | 目前 CryptoPet V5.3 展示頁 |
| `cryptopet.html` | 既有舊版前端，保留作歷史版本 |
| `3B132025實務專題計劃書.docx` | 原始實務專題計劃書 |
| `3B132025專題報告書.docx` | 既有報告書版本 |
| `3B132025口試簡報.pptx` | 口試簡報 |
| `CryptoPetNFT.sol` | 既有合約來源 |
| `hardhat-project/` | V2 合約、本機測試與部署設定 |

## 資料來源

行情資料使用 Binance Spot 公開 API。此原型用於專題展示與學習，不提供投資建議。

# CryptoPet｜加密貨幣行情學習原型

CryptoPet 是國立勤益科技大學資訊管理系的實務專題原型，透過寵物狀態呈現虛擬持倉損益，並提供行情區間資訊，協助加密貨幣初學者觀察市場變化。

## 展示頁面

- [線上展示入口](./index.html)
- [相容舊檔名的展示頁](./cryptopet.html)

目前 GitHub Pages 尚未啟用。要發布網站，請到 **Settings → Pages → Build and deployment**，選擇 **Deploy from a branch**、分支 `main`、資料夾 `/(root)`，再按 **Save**。發布後網址預計為 `https://kstapryun.github.io/ncut_project/`。

## 目前功能

- 使用 Binance 公開行情或模擬行情。
- 提供虛擬買入、賣出、持倉及損益資訊；不會向交易所下單。
- 透過寵物狀態呈現虛擬持倉變化，並可查看七天行情區間。
- 使用者資料存放在目前瀏覽器的 LocalStorage，沒有帳號系統或跨裝置同步。

## 合約與測試

- Remix 版本 V2 合約：[CryptoPetNFT.sol](./CryptoPetNFT.sol)
- Hardhat 專案：[hardhat-project](./hardhat-project/)
- 專題紀錄為 8 項 Hardhat 本機測試通過。
- Sepolia V2 部署、實際 Gas 費用及使用者測試仍待完成。

合約不會驗證前端 LocalStorage 中的養成歷程；NFT 只記錄鑄造時的幣種、成熟階段、稀有度與時間。實際鑄造前，需先部署 V2 合約並更新展示頁中的合約地址。稀有度是教學展示機制，尚未驗證統計公平性。

## 檔案導覽

| 檔案 | 說明 |
| --- | --- |
| `index.html`、`cryptopet.html` | 目前 V5.3 前端展示頁 |
| `CryptoPetNFT.sol` | 可在 Remix 使用的 V2 合約 |
| `hardhat-project/` | V2 合約、本機測試及 Sepolia 部署設定 |
| `3B132025實務專題計劃書.docx` | 專題計劃書 |
| `3B132025專題報告書.docx` | 報告書 |
| `3B132025口試簡報.pptx` | 口試簡報 |

## 執行說明

直接用瀏覽器開啟 HTML 頁面。即時行情和 ethers.js CDN 需要網路；展示時可選擇模擬行情。

Hardhat 測試請進入 `hardhat-project` 後執行 `npm install`，再執行 `npm test`。部署設定請參閱該資料夾的 README。不要上傳 `.env`、錢包私鑰或助記詞。

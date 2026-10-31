# CryptoPet NFT 合約規格

## V2 生命週期

遊戲在前端完成虛擬持倉與寵物養成。寵物達成熟條件後，使用者可呼叫 mintPet(symbol) 將成熟寵物鑄造成 ERC-721 NFT。合約保存幣種、成熟階段、鑄造時產生的稀有度與時間；getPet(tokenId) 可讀取鏈上資料。

遊戲養成紀錄和虛擬持倉仍存在瀏覽器 LocalStorage。合約不會驗證這段前端歷程，所以 NFT 表示鑄造時記錄的寵物資料，不是完整鏈上遊戲紀錄。V2 沒有獨立的鏈上 evolve()；成熟前的進化由遊戲本地規則管理。

## 唯一介面

- contractVersion()：回傳 2，供前端辨認合約版本。
- mintPet(string symbol)：支援 BTC、ETH、SOL、BNB、DOGE，最低鑄造費 0.001 ETH。新 NFT 記錄為成熟期，並於鑄造時取得稀有度。
- getPet(uint256 tokenId)：回傳幣種、階段、稀有度和鑄造時間。
- withdraw()：合約擁有者提領鑄造費。

Remix 版來源位於 報告書orPPT截圖/CryptoPetNFT.sol；Hardhat 版位於 contracts/CryptoPetNFT.sol。兩份使用相同的 V2 介面與邏輯，只因編譯環境而使用不同的 OpenZeppelin 匯入路徑。

## 本機編譯與測試

在 cryptopet 目錄安裝 package.json 指定的依賴：

npm install

完成後可執行：

npx hardhat compile
npx hardhat test

測試涵蓋合約版本、支援幣種、鑄造費、成熟階段、稀有度範圍、查詢不存在的 Token ID 和提領權限。稀有度範圍測試不代表機率分布或公平性已獲統計驗證。

## Sepolia 部署

設定 .env 中的 Sepolia RPC URL、測試帳戶私鑰及 Etherscan API Key，再執行：

npx hardhat run scripts/deploy.js --network sepolia

部署後需將新合約地址更新至 cryptopet_v5_3.html 的 CONTRACT_ADDRESS。前端會先讀取 contractVersion()；舊版合約不相容時會停止鑄造，避免沿用舊地址卻誤以為鏈上已記錄成熟階段。此專案尚未由本次工作自動部署到 Sepolia。

## 隨機性與成本的說明

目前稀有度使用區塊資料雜湊映射至普通 60%、稀有 25%、史詩 12%、隱藏 3%。這是展示用機制，不應稱為不可預測、不可操控或已證明公平；正式公平隨機需另外設計並驗證，例如採用可驗證隨機服務。

Gas 應以實際交易回條的 gasUsed 記錄。getPet() 是 view 查詢；一般錢包讀取不會產生使用者支付的鏈上交易費，不能將模擬執行估算寫成實付 Gas.

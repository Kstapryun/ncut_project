# CryptoPet — 加密貨幣 NFT 寵物養成遊戲

## 專題資訊
- 學校：國立勤益科技大學 資訊管理系
- 專題生：游紹維 3B132025
- 指導教授：黃展鵬 教授

## 專題說明
結合 Ethereum 區塊鏈技術與遊戲化設計的加密貨幣養成遊戲系統。
每種幣種對應一隻 Q 萌動物，透過 ERC-721 NFT 鑄造與鏈上隨機進化機制，
讓用戶在遊玩過程中自然接觸加密貨幣知識。

## 檔案說明
| 檔案 | 說明 |
|------|------|
| CryptoPetNFT.sol | 智能合約（Solidity 0.8.20） |
| cryptopet.html | 前端遊戲（直接用瀏覽器開啟）|

## 如何執行前端遊戲
1. 下載 `cryptopet.html`
2. 用 Chrome 直接開啟
3. 不需要伺服器或安裝任何東西

## 如何測試智能合約
1. 開啟 [remix.ethereum.org](https://remix.ethereum.org)
2. 貼入 `CryptoPetNFT.sol` 內容
3. 編譯 → 部署 → 測試 mintPet / evolve / getPet

## 技術架構
- 智能合約：Solidity 0.8.20 + OpenZeppelin ERC-721
- 測試環境：Remix IDE + Remix VM
- 前端：HTML / CSS / JavaScript（純靜態）

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/access/Ownable.sol";

/**
 * @title CryptoPetNFT
 * @dev 加密寵物 NFT 合約
 *      ERC-721 鑄造 + 鏈上隨機進化系統
 *      國立勤益科技大學 資訊管理系 專題
 *      專題生：游紹維 3B132025
 */
contract CryptoPetNFT is ERC721, Ownable {

    uint256 public constant MINT_FEE = 0.001 ether;

    struct Pet {
        string  symbol;   // 幣種代號 e.g. "BTC"
        uint8   stage;    // 形態：0=幼年期 1=成長期 2=成熟期
        uint8   rarity;   // 稀有度：0=普通 1=稀有 2=史詩 3=隱藏
        uint256 bornAt;   // 鑄造時間戳
    }

    uint256 private _nextTokenId = 1;
    mapping(uint256 => Pet) public pets;

    event PetMinted(uint256 tokenId, address owner, string symbol);
    event PetEvolved(uint256 tokenId, uint8 newStage, uint8 rarity);

    constructor() ERC721("CryptoPet", "CPET") Ownable(msg.sender) {}

    /**
     * @notice 鑄造新寵物 NFT
     * @param symbol 幣種代號（如 BTC、ETH、SOL）
     */
    function mintPet(string calldata symbol) external payable returns (uint256) {
        require(msg.value >= MINT_FEE, "insufficient fee");

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

        pets[tokenId] = Pet({
            symbol:  symbol,
            stage:   0,
            rarity:  0,
            bornAt:  block.timestamp
        });

        emit PetMinted(tokenId, msg.sender, symbol);
        return tokenId;
    }

    /**
     * @notice 觸發寵物進化
     * @dev 以 keccak256(block.timestamp, msg.sender, tokenId) % 100 決定稀有度
     *      機率分配：普通 60% / 稀有 25% / 史詩 12% / 隱藏 3%
     * @param tokenId 要進化的寵物 ID
     */
    function evolve(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "not owner");
        Pet storage pet = pets[tokenId];
        require(pet.stage < 2, "max stage");

        uint256 rand = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            msg.sender,
            tokenId
        ))) % 100;

        uint8 rarity;
        if      (rand < 60) rarity = 0;  // 普通 60%
        else if (rand < 85) rarity = 1;  // 稀有 25%
        else if (rand < 97) rarity = 2;  // 史詩 12%
        else                rarity = 3;  // 隱藏  3%

        pet.stage++;
        pet.rarity = rarity;

        emit PetEvolved(tokenId, pet.stage, rarity);
    }

    /**
     * @notice 查詢寵物完整屬性
     * @param tokenId 寵物 ID
     */
    function getPet(uint256 tokenId) external view returns (Pet memory) {
        return pets[tokenId];
    }

    /**
     * @notice 提領合約累積手續費（僅限擁有者）
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

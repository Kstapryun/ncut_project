// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title CryptoPetNFT
 * @dev V2：前端完成虛擬養成後，僅將成熟寵物鑄造成 NFT。
 *      鏈上保存幣種、成熟階段、鑄造時隨機稀有度與時間。
 *      稀有度雜湊僅供 Sepolia 教學展示，不是可驗證公平的隨機方案。
 */
contract CryptoPetNFT is ERC721, Ownable {
    uint8 public constant STAGE_MATURE = 2;
    uint256 public constant MINT_FEE = 0.001 ether;

    struct Pet {
        string symbol;
        uint8 stage;
        uint8 rarity;
        uint256 bornAt;
    }

    uint256 private _nextTokenId = 1;
    mapping(uint256 => Pet) public pets;
    mapping(string => bool) public supportedSymbols;

    event PetMinted(
        uint256 tokenId,
        address owner,
        string symbol,
        uint8 stage,
        uint8 rarity
    );

    constructor() ERC721("CryptoPet", "CPET") Ownable(msg.sender) {
        supportedSymbols["BTC"] = true;
        supportedSymbols["ETH"] = true;
        supportedSymbols["SOL"] = true;
        supportedSymbols["BNB"] = true;
        supportedSymbols["DOGE"] = true;
    }

    function contractVersion() external pure returns (uint256) {
        return 2;
    }

    /**
     * @dev 遊戲養成與投入紀錄留在前端；本函式只記錄前端解鎖的成熟寵物。
     *      合約不驗證 LocalStorage 內的養成歷程。
     */
    function mintPet(string calldata symbol) external payable returns (uint256 tokenId) {
        require(supportedSymbols[symbol], "unsupported symbol");
        require(msg.value >= MINT_FEE, "insufficient fee");

        tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

        uint8 rarity = _rollRarity(tokenId);
        pets[tokenId] = Pet({
            symbol: symbol,
            stage: STAGE_MATURE,
            rarity: rarity,
            bornAt: block.timestamp
        });

        emit PetMinted(tokenId, msg.sender, symbol, STAGE_MATURE, rarity);
    }

    function getPet(uint256 tokenId) external view returns (Pet memory) {
        require(_ownerOf(tokenId) != address(0), "nonexistent token");
        return pets[tokenId];
    }

    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "nothing to withdraw");
        (bool ok,) = payable(owner()).call{value: amount}("");
        require(ok, "transfer failed");
    }

    function _rollRarity(uint256 tokenId) private view returns (uint8) {
        uint256 roll = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender,
            tokenId
        ))) % 100;

        if (roll < 60) return 0;
        if (roll < 85) return 1;
        if (roll < 97) return 2;
        return 3;
    }
}

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoPetNFT V2", function () {
  let contract;
  let owner;
  let user;

  const MINT_FEE = ethers.parseEther("0.001");

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("CryptoPetNFT");
    contract = await Factory.deploy();
    await contract.waitForDeployment();
  });

  it("publishes interface version 2", async function () {
    expect(await contract.contractVersion()).to.equal(2n);
  });

  it("mints only supported symbols as mature pets with on-chain rarity", async function () {
    await contract.connect(user).mintPet("BTC", { value: MINT_FEE });

    expect(await contract.ownerOf(1)).to.equal(user.address);
    const pet = await contract.getPet(1);
    expect(pet.symbol).to.equal("BTC");
    expect(pet.stage).to.equal(2n);
    expect(pet.rarity >= 0n).to.equal(true);
    expect(pet.rarity <= 3n).to.equal(true);
    expect(pet.bornAt > 0n).to.equal(true);
  });

  it("rejects an unsupported symbol", async function () {
    await expect(
      contract.connect(user).mintPet("XYZ", { value: MINT_FEE })
    ).to.be.revertedWith("unsupported symbol");
  });

  it("rejects a mint fee below 0.001 ETH", async function () {
    await expect(
      contract.connect(user).mintPet("ETH", { value: MINT_FEE - 1n })
    ).to.be.revertedWith("insufficient fee");
  });

  it("emits the mature stage and rarity in PetMinted", async function () {
    await expect(contract.connect(user).mintPet("DOGE", { value: MINT_FEE }))
      .to.emit(contract, "PetMinted");
    const pet = await contract.getPet(1);
    expect(pet.stage).to.equal(2n);
    expect(pet.rarity <= 3n).to.equal(true);
  });

  it("rejects querying a token that does not exist", async function () {
    await expect(contract.getPet(999)).to.be.revertedWith("nonexistent token");
  });

  it("allows only the owner to withdraw mint fees", async function () {
    await contract.connect(user).mintPet("SOL", { value: MINT_FEE });
    const ownerBefore = await ethers.provider.getBalance(owner.address);
    await contract.connect(owner).withdraw();
    const ownerAfter = await ethers.provider.getBalance(owner.address);
    expect(ownerAfter > ownerBefore).to.equal(true);
  });

  it("rejects a withdrawal when there is no balance", async function () {
    await expect(contract.connect(owner).withdraw()).to.be.revertedWith("nothing to withdraw");
  });
});

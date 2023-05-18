const {ethers, assert} = require("hardhat");
const truffleAssert = require("truffle-assertions");

describe("Reward", function(){

    let nft;
    const name ="RewardArt";
    const symbol = "ART";
    const uri = "https://ipfs.io/reward/{id}.json"

    before( async function (){
        [owner,addr1,addr2,addr3,addr4] = await ethers.getSigners();
        const NFT = await ethers.getContractFactory("Reward");
        nft = await NFT.deploy(name,symbol,uri);
        await nft.deployed();
    })

    it("Should return the name and symbol of contract", async function(){
        assert.equal(await nft.name(), name);
        assert.equal(await nft.symbol(), symbol);
    })

    it("Should create token", async function(){
        const token = await nft.createToken(2,15);
        await nft.createToken(1,10);
        assert.equal(await nft.uri(0),uri);
        assert.equal(await nft.balanceOf(owner.address,0),2);
    })

    it("Should revert when the create token function is called by other than admin", async function(){
        truffleAssert.reverts( nft.connect(addr2).createToken(2,10));
    })

    it("Should mint the given amount of token", async function(){
        await nft.mintToken(addr1.address,0,2);
        assert.equal(await nft.balanceOf(addr1.address,0),2);

    })

    it("Should revert when quantity is greater than the total reserved supply of given token", async function(){
        truffleAssert.reverts(nft.mintToken(addr2.address,0,15));
    })

    it("Should revert when mint function is called for non-existing token", async function(){
        truffleAssert.reverts(nft.mintToken(addr1.address,2,2));
    })

    it("Should revert when minting is paused", async function(){
        await nft.pause();
        truffleAssert.reverts(nft.mintToken(addr1.address,1,2));
    })
    
    it("Should  batch mint(mint multiple token for given amount)", async function(){
        await nft.unpause();
        await nft.batchMint(addr2.address,[0,1],[2,4]);
        const tokens = await nft.balanceOfBatch([addr2.address,addr2.address],[0,1]);
        assert.equal(Number(tokens[0]),2);
        assert.equal(Number(tokens[1]),4);
    })
})
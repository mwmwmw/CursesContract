const {nftData} = require("./testData");

const ABI = require("../artifacts/contracts/ReqsNFT.sol/ReqsNFT.json");

const configPath = `./scripts/config.${process.env.HARDHAT_NETWORK}.json`;
const config = require(configPath);

const contractAddress = config.MAIN_CONTRACT;
const contractABI = ABI.abi;

const main = async () => {
    const [owner] = await hre.ethers.getSigners();
    const nftContract = await new ethers.Contract(contractAddress, contractABI, owner);

    let wtx = await nftContract.withdraw();

    let contractBalance = await hre.ethers.provider.getBalance(contractAddress);
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    let obBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log(
      'Owner balance:',
      hre.ethers.utils.formatEther(obBalance)
    );

};


const runMain = async () => {

    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }

}

runMain();
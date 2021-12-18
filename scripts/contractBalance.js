const {nftData} = require("./testData");

const configPath = `./config.${process.env.HARDHAT_NETWORK}.json`;
const config = require(configPath);

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();

    console.log(owner.address);

    contractBalance = await hre.ethers.provider.getBalance(config.MAIN_CONTRACT);
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    contractBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log(
      'Owner balance:',
      hre.ethers.utils.formatEther(contractBalance)
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
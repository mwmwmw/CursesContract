
const { nftData } = require("./testData");

const { writeFile, copyFile } = require("./files");

const configPath = `./config.${process.env.HARDHAT_NETWORK}.json`;
const config = require(configPath);

const ABI = require("../artifacts/contracts/ReqsNFT.sol/ReqsNFT.json");

const contractAddress = config.MAIN_CONTRACT;
const contractABI = ABI.abi;

const main = async () => {
  const [owner] = await hre.ethers.getSigners();
  const nftContract = await new ethers.Contract(contractAddress, contractABI, owner)

  const renderFactory = await hre.ethers.getContractFactory("CurseGenerator");
  const renderContract = await renderFactory.deploy();
  await renderContract.deployed();

  config.RENDER_CONTRACT = renderContract.address;

  await nftContract.setRenderingContractAddress(renderContract.address);

  writeFile(`./scripts/${configPath}`, config);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

const { nftData } = require("./testData");

const configPath = `./config.${process.env.HARDHAT_NETWORK}.json`;
const config = require(configPath);
const { writeFile, copyFile } = require("./files");

const main = async () => {
  const nftFactory = await hre.ethers.getContractFactory("ReqsNFT");
  const nftContract = await nftFactory.deploy();
  await nftContract.deployed();

  config.MAIN_CONTRACT = nftContract.address;

  const renderFactory = await hre.ethers.getContractFactory("CurseGenerator");
  const renderContract = await renderFactory.deploy();
  await renderContract.deployed();

  await nftContract.setRenderingContractAddress(config.MAIN_CONTRACT);

  config.RENDER_CONTRACT = renderContract.address;

  console.log("Contract deployed to:", {...config});

  writeFile(`./scripts/${configPath}`, config);
  writeFile(`../app/src/config.${process.env.HARDHAT_NETWORK}.json`, {contract: config.MAIN_CONTRACT});

  await copyFile('./artifacts/contracts/ReqsNFT.sol/ReqsNFT.json', '../app/src/abi/ReqsNFT.json');

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
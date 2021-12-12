
const main = async () => {
    const nftFactory = await hre.ethers.getContractFactory("ReqsNFT");
    const nftContract = await nftFactory.deploy();
    await nftContract.deployed();

    console.log("Yo, Contract deployed to:", nftContract.address);


    let txn = await nftContract.GenNFT("My NFT", "", {gasLimit: "30000000"});

    console.log(txn)
    // Wait for it to be mined.
    await txn.wait();
  
    // Mint another NFT for fun.
    txn = await nftContract.GenNFT("My NFT", "", {gasLimit: "30000000"});

    console.log(txn)
    // Wait for it to be mined.
    await txn.wait();


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
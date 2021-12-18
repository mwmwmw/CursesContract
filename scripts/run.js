const { nftData } = require("./testData");

const price = 5000000000000000;
const limit = 10;

const main = async () => {
    const [owner, randomPerson, anotherRandom] = await hre.ethers.getSigners();
    const nftFactory = await hre.ethers.getContractFactory("ReqsNFT");
    const nftContract = await nftFactory.deploy();
    await nftContract.deployed();

    const renderFactory = await hre.ethers.getContractFactory("CurseGenerator");
    const renderContract = await renderFactory.deploy();
    await renderContract.deployed();

    await nftContract.setRenderingContractAddress(renderContract.address);

    var nftGen = nftData();

    let txn;

    txn = await nftContract.GenNFT(...nftGen.next().value, { value: price, gasLimit: 3000000 });

    console.log(txn)
    // Wait for it to be mined.
    await txn.wait();

    console.log("Genning 10000 NFTs");
    for (let i = 0; i < limit / 2; i++) {
        txn = await nftContract.connect(randomPerson).GenNFT(...nftGen.next().value, { value: price, gasLimit: 3000000 });
        await txn.wait();
        if (i % 100 === 0) {
            console.log(`${(i / limit) * 100}% complete`);
        }
    }
    for (let i = 0; i < limit / 2; i++) {
        txn = await nftContract.connect(anotherRandom).GenNFT(...nftGen.next().value, { value: price, gasLimit: 3000000 });
        await txn.wait();
        if (i % 100 === 0) {
            console.log(`${(i / limit) * 100}% complete`);
        }
    }

    try {
        await nftContract.connect(randomPerson).transferFrom(randomPerson.address, anotherRandom.address, 6);
        await nftContract.connect(anotherRandom).transferFrom(anotherRandom.address, randomPerson.address, 0);
    } catch (err) {
        console.log("Can't Transfer");
    }


    // console.log(await nftContract.tokenURI(limit - 1));

    contractBalance = await hre.ethers.provider.getBalance(randomPerson.address);
    console.log(
        'Random balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    contractBalance = await hre.ethers.provider.getBalance(nftContract.address);
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    contractBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log(
        'Owner balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    let wdbal = await hre.ethers.provider.getBalance(nftContract.address);
    let wtx;

    try {
        wtx = await nftContract.connect(randomPerson).withdrawl(randomPerson.address, wdbal);
    } catch (err) {
        console.log("Only the owner can withdrawl!");
    }

    wtx = await nftContract.withdraw();

    contractBalance = await hre.ethers.provider.getBalance(nftContract.address);
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );

    contractBalance = await hre.ethers.provider.getBalance(owner.address);
    console.log(
        'Owner balance:',
        hre.ethers.utils.formatEther(contractBalance) - 10000
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
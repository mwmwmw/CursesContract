
function rint() {
  return Math.floor(Math.random() * 1000000)%65535;
}

function rint8() {
  return Math.floor(Math.random() * 1000000)%256;
}

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('ReqsNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);


  for (var i = 0; i < 5; i++) {
    const [name, desc, nb] = [`Noise Block ${i}`, `${new Array(Math.ceil(3 + Math.random()*3)).fill(0).map(v=>new Array(Math.ceil(Math.random()*6)).fill('x').join("")).join(" ")}`, [rint(), rint(), rint(), rint8(), rint(), rint8()]];
    let txn = await nftContract.GenNFT(name, desc, nb, {gasLimit: 30000000});
    console.log("Minted", name, desc, nb);
    await txn.wait();
  }

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
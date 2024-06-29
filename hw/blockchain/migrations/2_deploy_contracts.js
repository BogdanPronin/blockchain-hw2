const TestWallet = artifacts.require("TestWallet");

module.exports = async function (deployer) {
  // Deploy the TestWallet contract
  await deployer.deploy(TestWallet);
  const walletInstance = await TestWallet.deployed();
  console.log("Wallet deployed at address:", walletInstance.address);
};

const Migrations = artifacts.require("Migrations");
const TokenSeller = artifacts.require("TokenSeller");
// const WalletLocking = artifacts.require("WalletLocking");


module.exports = function (deployer) {
  // deployer.deploy(Migrations);
  // deployer.deploy(LPLocking);
  deployer.deploy(TokenSeller);
};

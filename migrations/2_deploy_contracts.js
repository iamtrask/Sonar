var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var ModelRepository = artifacts.require("./ModelRepository.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.deploy(ModelRepository);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);

};

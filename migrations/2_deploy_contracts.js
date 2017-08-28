var ModelRepository = artifacts.require('./ModelRepository.sol')

module.exports = function (deployer) {
  deployer.deploy(ModelRepository)
}

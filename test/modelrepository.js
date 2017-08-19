var ModelRepository = artifacts.require('./ModelRepository.sol')

contract('ModelRepository', function(accounts) {
  it('can be deployed', function() {
    return ModelRepository.deployed().then(function(instance) {
      assert.ok(instance !== undefined)
    })
  })
})

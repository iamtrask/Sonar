var ModelRepository = artifacts.require('./ModelRepository.sol')

const hexToString = hexString => {
  return new Buffer(hexString.replace('0x', ''), 'hex').toString()
}

const splitIpfsHashInMiddle = ipfsHash => {
  return [
    ipfsHash.substring(0, 32),
    ipfsHash.substr(32) + '0'.repeat(18)
  ]
}

const firstModel = {
  id: 0,
  bountyInWei: 10000,
  initialError: 42,
  targetError: 1337,
  twoPartIpfsHash: splitIpfsHashInMiddle('QmWmyoMoctfbAaiEs2G46gpeUmhqFRDW6KWo64y5r581Vz')
}

const addFirstModel = async function(modelRepositoryContract, modelOwner) {
  modelRepositoryContract.addModel(firstModel.twoPartIpfsHash, firstModel.initialError, firstModel.targetError, {
    from: modelOwner,
    value: firstModel.bountyInWei
  })
}

contract('ModelRepository', accounts => {
  const oscarTheModelOwner = accounts[0]

  it('allows anyone to add a model', async () => {
    const modelRepositoryContract = await ModelRepository.deployed();
    await addFirstModel(modelRepositoryContract, oscarTheModelOwner)

    const model = await modelRepositoryContract.getModel.call(firstModel.id)
    assert.equal(model[0], oscarTheModelOwner, 'owner persisted')
    assert.equal(model[1], firstModel.bountyInWei, 'bounty persisted')
    assert.equal(model[2], firstModel.initialError, 'initial_error persisted')
    assert.equal(model[3], firstModel.targetError, 'target_error persisted')
    assert.equal(hexToString(model[4][0]), firstModel.twoPartIpfsHash[0], 'ipfshash persisted')
    assert.equal(hexToString(model[4][1]), firstModel.twoPartIpfsHash[1], 'ipfshash persisted')
  })

  it('allows anyone to add a gradient', async () => {
    const twoPartIpfsHash = splitIpfsHashInMiddle('QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG')
    const modelRepositoryContract = await ModelRepository.deployed();
    await modelRepositoryContract.addGradient(firstModel.id, twoPartIpfsHash, {
      from: oscarTheModelOwner
    })

    const gradientId = 0
    const gradient = await modelRepositoryContract.getGradient.call(firstModel.id, gradientId)

    assert.equal(gradient[0], gradientId, 'has an id')
    assert.equal(gradient[1], oscarTheModelOwner, 'has a creator')
    assert.equal(hexToString(gradient[2][0]), twoPartIpfsHash[0], 'ipfshash persisted')
    assert.equal(hexToString(gradient[2][1]), twoPartIpfsHash[1], 'ipfshash persisted')
    assert.equal(gradient[3], 0, 'error defaults to 0')
    assert.equal(gradient[4][0], 0, 'weights are initially 0')
    assert.equal(gradient[4][1], 0, 'weights are initially 0')
  })

  it('will not add gradients to models which do not exist', async () => {
    const twoPartIpfsHash = splitIpfsHashInMiddle('QmWmraMoctfbAaiEs2G46gpeUmhqFRDW6KWo64y5r581Vz')
    const modelRepositoryContract = await ModelRepository.deployed()
    const modelWhichDoesntExist = 1

    try {
      await modelRepositoryContract.addGradient(modelWhichDoesntExist, twoPartIpfsHash, {
        from: oscarTheModelOwner
      })
    } catch (error) {
      assert.ok(error)
      return
    }
    assert.fail()
  })

})

contract('ModelRepository - Evaluating Gradients', accounts => {
  const oscarTheModelOwner = accounts[0]
  const patTheGradientProvider = accounts[1]

  it('will not evaluate the same gradient twice', async () => {
    const modelRepositoryContract = await ModelRepository.deployed();
    await addFirstModel(modelRepositoryContract, oscarTheModelOwner)
    await modelRepositoryContract.addGradient(firstModel.id, firstModel.twoPartIpfsHash, {
      from: patTheGradientProvider
    })
    const updatedWeights = splitIpfsHashInMiddle('QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG')

    const newError = 1;
    await modelRepositoryContract.evalGradient(0, newError, updatedWeights, {
      from: oscarTheModelOwner
    })
    const newErrorAttempt = 2;
    const evaluatedGradient = await modelRepositoryContract.getGradient.call(firstModel.id, 0)
    await modelRepositoryContract.evalGradient(0, newErrorAttempt, updatedWeights, {
      from: oscarTheModelOwner
    })
    const unevaluatedGradient = await modelRepositoryContract.getGradient.call(firstModel.id, 0)

    assert.equal(evaluatedGradient[3], newError, 'new error set')
    assert.notEqual(unevaluatedGradient[3], newErrorAttempt, 'error not updated')
  })
})

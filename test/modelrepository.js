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

const firstGradient = {
  id: 0,
  twoPartIpfsHash: splitIpfsHashInMiddle('QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG')
}

const addFirstModel = async function(modelRepositoryContract, modelOwner) {
  modelRepositoryContract.addModel(firstModel.twoPartIpfsHash, firstModel.initialError, firstModel.targetError, {
    from: modelOwner,
    value: firstModel.bountyInWei
  })
}

const addFirstGradientToFirstModel = async function(modelRepositoryContract, gradientProvider) {
  modelRepositoryContract.addGradient(firstGradient.id, firstGradient.twoPartIpfsHash, {
    from: gradientProvider
  })
}

const getFirstGradient = function(modelRepositoryContract) {
  return modelRepositoryContract.getGradient.call(firstModel.id, firstGradient.id)
}

contract('ModelRepository', accounts => {
  const oscarTheModelOwner = accounts[0]
  const patTheGradientProvider = accounts[1]

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
    const modelRepositoryContract = await ModelRepository.deployed();
    await addFirstGradientToFirstModel(modelRepositoryContract, patTheGradientProvider)

    const addedGradient = await getFirstGradient(modelRepositoryContract)

    assert.equal(addedGradient[0], firstGradient.id, 'has an id')
    assert.equal(addedGradient[1], patTheGradientProvider, 'has a creator')
    assert.equal(hexToString(addedGradient[2][0]), firstGradient.twoPartIpfsHash[0], 'ipfshash persisted')
    assert.equal(hexToString(addedGradient[2][1]), firstGradient.twoPartIpfsHash[1], 'ipfshash persisted')
    assert.equal(addedGradient[3], 0, 'error defaults to 0')
    assert.equal(addedGradient[4][0], 0, 'weights are initially 0')
    assert.equal(addedGradient[4][1], 0, 'weights are initially 0')
  })

  it('will not add gradients to models which do not exist', async () => {
    const twoPartIpfsHash = splitIpfsHashInMiddle('QmWmraMoctfbAaiEs2G46gpeUmhqFRDW6KWo64y5r581Vz')
    const modelRepositoryContract = await ModelRepository.deployed()
    const modelWhichDoesntExist = 1

    try {
      await modelRepositoryContract.addGradient(modelWhichDoesntExist, twoPartIpfsHash, {
        from: patTheGradientProvider
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
    await addFirstGradientToFirstModel(modelRepositoryContract, patTheGradientProvider)
    const updatedWeights = splitIpfsHashInMiddle('QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG')

    const newError = 1;
    await modelRepositoryContract.evalGradient(firstGradient.id, newError, updatedWeights, {
      from: oscarTheModelOwner
    })
    const newErrorAttempt = 2;
    const evaluatedGradient = await getFirstGradient(modelRepositoryContract)
    const secondAttemptWeights = splitIpfsHashInMiddle('QmYwARJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG')
    await modelRepositoryContract.evalGradient(firstGradient.id, newErrorAttempt, secondAttemptWeights, {
      from: oscarTheModelOwner
    })
    const evaluatedGradientAfterSecondAttempt = await getFirstGradient(modelRepositoryContract)

    assert.equal(evaluatedGradient[3], newError, 'new error set after first attempt')
    assert.equal(hexToString(evaluatedGradient[4][0]), firstGradient.twoPartIpfsHash[0], 'ipfshash persisted')
    assert.equal(hexToString(evaluatedGradient[4][1]), firstGradient.twoPartIpfsHash[1], 'ipfshash persisted')
    assert.equal(evaluatedGradientAfterSecondAttempt[3], newError, 'error not updated during second attempt')
    assert.equal(hexToString(evaluatedGradientAfterSecondAttempt[4][0]), firstGradient.twoPartIpfsHash[0],
      'weights not updated during second attempt')
    assert.equal(hexToString(evaluatedGradientAfterSecondAttempt[4][1]), firstGradient.twoPartIpfsHash[1],
      'weights not updated during second attempt')
  })
})

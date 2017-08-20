var ModelRepository = artifacts.require('./ModelRepository.sol')

const hexToString = hexString => {
  return new Buffer(hexString.replace('0x', ''), 'hex').toString()
}

contract('ModelRepository', accounts => {
  const ulyssesTheUser = accounts[0]

  it('allows anyone to add a model', async () => {
    const ipfsHash = 'QmWmyoMoctfbAaiEs2G46gpeUmhqFRDW6KWo64y5r581Vz'
    const twoPartIpfsHash = [
      ipfsHash.substring(0, 32),
      ipfsHash.substr(32) + '0'.repeat(18)
    ]
    const bountyInWei = 10000
    const initialError = 42
    const targetError = 1337

    const modelRepositoryContract = await ModelRepository.deployed();
    await modelRepositoryContract.addModel(twoPartIpfsHash, initialError, targetError, {
        from: ulyssesTheUser,
        value: bountyInWei
    })

    const model = await modelRepositoryContract.getModel.call(0)
    assert.equal(model[0], ulyssesTheUser, 'owner persisted')
    assert.equal(model[1], bountyInWei, 'bounty persisted')
    assert.equal(model[2], initialError, 'initial_error persisted')
    assert.equal(model[3], targetError, 'target_error persisted')
    assert.equal(hexToString(model[4][0]), twoPartIpfsHash[0], 'ipfshash persisted')
    assert.equal(hexToString(model[4][1]), twoPartIpfsHash[1], 'ipfshash persisted')
  })
})

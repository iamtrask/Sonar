var TrainingGrid = artifacts.require('TrainingGrid');

function arrayToAddress (hexStrings) {
  return hexStrings.map(e => Buffer.from(e.slice(2), 'hex').toString().split('\x00')[0])
  .join('')
}

function addressToArray (ipfsAddress) {
  const targetLength = 64 // fill the address with 0 at the end to this length
  const parts = ipfsAddress.match(/.{1,32}/g) // split into 32-chars
  .map(part => part.split('').map(c => c.charCodeAt(0).toString(16)).join('')) // turn each part into a hexString address
  .map(part => part.concat('0'.repeat(targetLength - part.length))) // 0 pad at the end
  .map(part => '0x' + part) // prefix as hex
  return parts
}

var config = {
  experimentAddress: 'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUk',
  bounty: 100
};

contract('TrainingGrid', function(accounts) {
  it("should add a new experiment", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var experimentAddress = addressToArray(config.experimentAddress);
      return instance.addExperiment(experimentAddress, {
        value: config.bounty
      });
    }).then(function() {
      // assert
    });
  });
  it("should count experiments", function() {
    return TrainingGrid.deployed().then(function(instance) {
      return instance.countExperiments.call();
    }).then(function(res) {
      experimentCount = res.toNumber();
      assert.equal(experimentCount, 1, "Address should match");
    });
  });
  it("should list experiments", function() {
    return TrainingGrid.deployed().then(function(instance) {
      return instance.getExperimentIds.call();
    }).then(function(res) {
      console.log("res", res);
    });
  });
  it("should get experiment", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var experimentAddress = addressToArray(config.experimentAddress);
      return instance.getExperiment.call(experimentAddress);
    }).then(function(res) {
      console.log("res", res);
      var owner = res[0];
      var bounty = res[1].toNumber();
      var experimentAddress = arrayToAddress(res[2]);
      assert.equal(owner, accounts[0], "Owner should match");
      assert.equal(bounty, config.bounty, "Bounty should match");
      assert.equal(experimentAddress, config.experimentAddress, "Address should match");
    });
  });
});

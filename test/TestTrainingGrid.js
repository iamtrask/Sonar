var TrainingGrid = artifacts.require('TrainingGrid');
const web3utils = require('web3-utils');

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
  weightsAddress: [
                    'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUk',
                    'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUk'
                  ],
  bounty: 100
};

contract('TrainingGrid', function(accounts) {
  it("should add a new experiment", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var experimentAddress = addressToArray(config.experimentAddress);
      var weightAddresses = Array();

      for(var i = 0; i < config.weightsAddress.length; i++) {
        var array = addressToArray(config.weightsAddress[i]);
        var k = web3utils.soliditySha3({type: 'bytes32', value: array});
        weightAddresses.push(k);
      }

      return instance.addExperiment(experimentAddress, weightAddresses, {
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
      var id = res[0];
      var owner = res[1];
      var bounty = res[2].toNumber();
      var experimentAddress = arrayToAddress(res[3]);
      assert.equal(id, web3utils.soliditySha3({type: 'bytes32', value: res[3]}));
      assert.equal(owner, accounts[0], "Owner should match");
      assert.equal(bounty, config.bounty, "Bounty should match");
      assert.equal(experimentAddress, config.experimentAddress, "Address should match");
    });
  });
});

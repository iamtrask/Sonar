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

function addressToId (ipfsAddress) {
  return web3utils.soliditySha3({type: 'bytes32', value: addressToArray(ipfsAddress)});
}

function arrayToId (ipfsArray) {
  return web3utils.soliditySha3({type: 'bytes32', value: ipfsArray});
}

var config = {
  experimentAddress: 'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUA',
  jobAddress: [
                'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUB',
                'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUC'
              ],
  resultAddress: 'QmNqVVej89i1xDGDgiHZzXbiX9RypoFGFEGHgWqeZBRaUD',
  bounty: 100
};

contract('TrainingGrid', function(accounts) {
  it("should add a new experiment", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var experimentAddress = addressToArray(config.experimentAddress);
      var jobAddresses = Array();

      for(var i = 0; i < config.jobAddress.length; i++) {
        var array = addressToArray(config.jobAddress[i]);
        jobAddresses.push(array[0]);
        jobAddresses.push(array[1]);
      }

      return instance.addExperiment(experimentAddress, jobAddresses, {
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
      assert.equal(res.length, 1, "Experiment count should match");
    });
  });
  it("should get experiment", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var experimentId = addressToId(config.experimentAddress);
      return instance.getExperiment.call(experimentId);
    }).then(function(res) {
      var experimentAddress = arrayToAddress(res[0]);
      var owner = res[1];
      var bounty = res[2].toNumber();
      assert.equal(experimentAddress, config.experimentAddress, "Address should match");
      assert.equal(owner, accounts[0], "Owner should match");
      assert.equal(bounty, config.bounty, "Bounty should match");
    });
  });
  it("get available job ids", function() {
    return TrainingGrid.deployed().then(function(instance) {
      return instance.getAvailableJobIds.call();
    }).then(function(res) {
      assert.equal(res.length, 2, "Job count should match");
    })
  })
  it("add result", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var jobAddress = addressToArray(config.jobAddress[0]);
      var resultAddress = addressToArray(config.resultAddress);
      return instance.addResult(jobAddress, resultAddress, {});
    }).then(function(res) {
      // assert
    })
  })
  it("get available job ids", function() {
    return TrainingGrid.deployed().then(function(instance) {
      return instance.getAvailableJobIds.call();
    }).then(function(res) {
      assert.equal(res.length, 2, "Job count should match");
    })
  })
  it("should get job", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var jobId = addressToId(config.jobAddress[0]);
      return instance.getJob.call(jobId);
    }).then(function(res) {
      var jobAddress = arrayToAddress(res[0]);
      var experimentAddress = arrayToAddress(res[1]);
      assert.equal(jobAddress, config.jobAddress[0], "Job address should match");
      assert.equal(experimentAddress, config.experimentAddress, "Experiment address should match");
    });
  });
  it("get results count", function() {
    return TrainingGrid.deployed().then(function (instance) {
      var jobId = addressToId(config.jobAddress[0]);
      return instance.countResults.call(jobId);
    }).then(function(res) {
      var count = res.toNumber();

      assert.equal(count, 1, "Results count should equal 1");
    })
  });
  it("get results", function() {
    return TrainingGrid.deployed().then(function(instance) {
      var jobId = addressToId(config.jobAddress[0]);
      return instance.getResults.call(jobId);
    }).then(function(res) {
      var resultAddress = res[0];
      var owner = res[1];
      assert.equal(config.resultAddress, arrayToAddress(resultAddress));
      assert.equal(owner, accounts[0]);
    })
  })
});

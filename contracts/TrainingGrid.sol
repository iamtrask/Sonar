pragma solidity ^0.4.17;

contract TrainingGrid {

  struct Experiment {
    bytes32 id;
    address owner;
    uint bounty;
    bytes32[] ipfs;
  }

  mapping(bytes32 => Experiment) experiments;
  bytes32[] experimentIds;

  function addExperiment(bytes32[] experimentAddress) public payable {
    Experiment memory experiment;
    experiment.id = keccak256(experimentAddress);
    experiment.owner = msg.sender;
    experiment.bounty = msg.value;
    experiment.ipfs = experimentAddress;

    experiments[experiment.id] = experiment;
    experimentIds.push(experiment.id);
  }

  function countExperiments() constant public returns (uint256 experimentCount) {
    return experimentIds.length;
  }

  function getExperimentIds() constant public returns (bytes32[]) {
    return experimentIds;
  }

  function getExperiment(bytes32[] experimentAddress) constant public returns (address, uint, bytes32[]) {
    Experiment memory experiment;
    bytes32 id = keccak256(experimentAddress);
    experiment = experiments[id];
    return (experiment.owner, experiment.bounty, experiment.ipfs);
  }
}

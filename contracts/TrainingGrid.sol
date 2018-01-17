pragma solidity ^0.4.17;

contract TrainingGrid {

  struct Experiment {
    bytes32 id;
    address owner;
    uint bounty;
    bytes32[] ipfs;
    bytes32[] jobs;
  }

  mapping(bytes32 => Experiment) experiments;
  bytes32[] experimentIds;

  function addExperiment(bytes32[] experimentAddress, bytes32[] jobIds) public payable {
    Experiment memory experiment;
    experiment.id = keccak256(experimentAddress);
    experiment.owner = msg.sender;
    experiment.bounty = msg.value;
    experiment.ipfs = experimentAddress;
    experiment.jobs = jobIds;

    experiments[experiment.id] = experiment;
    experimentIds.push(experiment.id);
  }

  function countExperiments() public constant returns (uint256 experimentCount) {
    return experimentIds.length;
  }

  function getExperimentIds() public constant returns (bytes32[]) {
    return experimentIds;
  }

  function getExperiment(bytes32[] experimentAddress) public constant returns (address, uint, bytes32[]) {
    Experiment memory experiment;
    bytes32 id = keccak256(experimentAddress);
    experiment = experiments[id];
    return (experiment.owner, experiment.bounty, experiment.ipfs);
  }
}

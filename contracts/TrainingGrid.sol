pragma solidity ^0.4.17;

contract TrainingGrid {

  struct Result {
    address owner;
    bytes32[] ipfs;
  }

  struct Job {
    bytes32 id;
    bytes32 experimentId;
    bytes32[] ipfs;
  }

  struct Experiment {
    bytes32 id;
    address owner;
    uint bounty;
    bytes32[] ipfs;
    bytes32[] jobs;
  }

  mapping(bytes32 => Result[]) results;
  mapping(bytes32 => Job) jobs;
  mapping(bytes32 => Experiment) experiments;

  bytes32[] availableJobIds;
  bytes32[] experimentIds;

  function addExperiment(bytes32[] experimentAddress, bytes32[] jobAddresses) public payable {
    Experiment memory experiment;
    experiment.id = keccak256(experimentAddress);
    experiment.owner = msg.sender;
    experiment.bounty = msg.value;
    experiment.ipfs = experimentAddress;

    experiments[experiment.id] = experiment;
    experimentIds.push(experiment.id);

    addJobs(experiment.id, jobAddresses);
  }

  function countExperiments() public view returns (uint256 experimentCount) {
    return experimentIds.length;
  }

  function getExperimentIds() public view returns (bytes32[]) {
    return experimentIds;
  }

  function getExperiment(bytes32[] experimentAddress) public view returns (bytes32, address, uint, bytes32[]) {
    Experiment memory experiment;
    bytes32 id = keccak256(experimentAddress);
    experiment = experiments[id];
    return (id, experiment.owner, experiment.bounty, experiment.ipfs);
  }

  function addJobs(bytes32 experimentId, bytes32[] jobAddresses) internal {
    for (uint i = 0; i < jobAddresses.length; i += 2) {
      bytes32[] memory jobAddress = new bytes32[](2);
      jobAddress[0] = jobAddresses[i];
      jobAddress[1] = jobAddresses[i + 1];
      addJob(experimentId, jobAddress);
    }
  }

  function addJob(bytes32 experimentId, bytes32[] jobAddress) internal {
    Job memory job;
    job.ipfs = jobAddress;
    job.experimentId = experimentId;
    job.id = keccak256(job.ipfs);
    jobs[job.id] = job;
    availableJobIds.push(job.id);
  }

  function getAvailableJobIds() public view returns (bytes32[]) {
    return availableJobIds;
  }

  function addResult(bytes32[] jobAddress, bytes32[] resultAddress) public payable {
    Result memory result;
    bytes32 jobId = keccak256(jobAddress);
    result.owner = msg.sender;
    result.ipfs = resultAddress;
    results[jobId].push(result);
    completeJob(jobId);
  }

  function completeJob(bytes32 jobId) internal {
    // delete assigns 0 to the element (it does not remove it)
    for (uint i = 0; i < availableJobIds.length; i++) {
      if (availableJobIds[i] == jobId) {
        delete availableJobIds[i];
        break;
      }
    }
  }

  function countResults(bytes32 jobId) public view returns (uint256 resultsCount) {
    return results[jobId].length;
  }

  function getResults(bytes32 jobId) public view returns (address, bytes32[]) {
    Result[] memory jobResults = results[jobId];
    Result memory result = jobResults[0];
    return (result.owner, result.ipfs);
  }
}

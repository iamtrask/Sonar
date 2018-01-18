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

  Job[] availableJobs;
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

  function countExperiments() constant public returns (uint256 experimentCount) {
    return experimentIds.length;
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
    availableJobs.push(job);
  }

  function countAvailableJobs() constant public returns (uint256 availableJobsCount) {
    return availableJobs.length;
  }

  function getAvailableJob() public returns (bytes32, bytes32, bytes32[]) {
    require(availableJobs.length > 0);

    Job memory job = availableJobs[0];
    delete availableJobs[0];
    return (job.id, job.experimentId, job.ipfs);
  }

  function submitResult(bytes32 jobId, bytes32[] resultAddress) public {
    Result memory result;
    result.owner = msg.sender;
    result.ipfs = resultAddress;
    results[jobId].push(result);
  }

  function getResults(bytes32 jobId) public constant returns (address, bytes32[]) {
    Result[] memory jobResults = results[jobId];
    Result memory result = jobResults[0];
    return (result.owner, result.ipfs);
  }

  function getExperimentIds() constant public returns (bytes32[]) {
    return experimentIds;
  }

  function getExperiment(bytes32[] experimentAddress) public constant returns (bytes32, address, uint, bytes32[]) {
    Experiment memory experiment;
    bytes32 id = keccak256(experimentAddress);
    experiment = experiments[id];
    return (id, experiment.owner, experiment.bounty, experiment.ipfs);
  }
}

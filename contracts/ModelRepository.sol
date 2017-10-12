pragma solidity ^0.4.4;


contract ModelRepository {

  Model[] models;
  Gradient[] grads;

  struct IPFS {
    bytes32 first;
    bytes32 second;
  }

  struct Gradient {

    bool evaluated;

    // submitted from miner
    address from;
    IPFS grads;
    uint modelId;

    // submitted from trainer
    uint newModelError;
    IPFS newWeights;
  }

  struct Model {

    address owner;

    IPFS initialWeights;
    IPFS weights;

    uint bounty;

    uint initialError;
    uint bestError;
    uint targetError;
  }

  modifier onlyByModelOwner(uint gradientId) {
    require(msg.sender == models[grads[gradientId].modelId].owner);
    _;
  }

  modifier onlyIfGradientNotYetEvaluated(uint gradientId) {
    require(grads[gradientId].evaluated == false);
    _;
  }

  function transferAmount(address receiver, uint amount) private {
    assert(receiver.send(amount));
  }

  function addModel(bytes32[] weights, uint initialError, uint targetError) payable {

    IPFS memory ipfsWeights;
    ipfsWeights.first = weights[0];
    ipfsWeights.second = weights[1];

    Model memory newModel;
    newModel.weights = ipfsWeights;
    newModel.initialWeights = ipfsWeights;

    newModel.bounty = msg.value;
    newModel.owner = msg.sender;

    newModel.initialError = initialError;
    newModel.bestError = initialError;
    newModel.targetError = targetError;

    models.push(newModel);
  }

  function incentiveCalculate(uint bounty, uint totalError, uint solvedError) returns(uint total) {
    total = ((bounty/totalError) * solvedError);
    return total;
  }

  function evalGradient(uint gradientId, uint newModelError, bytes32[] newWeightsAddress) onlyByModelOwner(gradientId) onlyIfGradientNotYetEvaluated(gradientId) {
    grads[gradientId].newWeights.first = newWeightsAddress[0];
    grads[gradientId].newWeights.second = newWeightsAddress[1];
    grads[gradientId].newModelError = newModelError;

    Model model = models[grads[gradientId].modelId];
    if (newModelError < model.bestError && model.targetError < model.bestError) {
      uint totalError= model.initialError - model.targetError;
      uint solvedError= model.bestError - newModelError;

      uint incentive = incentiveCalculate(model.bounty, totalError, solvedError);

      model.bestError = newModelError;
      model.weights = grads[gradientId].newWeights;
      transferAmount(grads[gradientId].from, incentive);
    }

    grads[gradientId].evaluated = true;
  }

  function addGradient(uint modelId, bytes32[] gradientAddress) {
    require(models[modelId].owner != 0);
    IPFS memory ipfsGradientAddress;
    ipfsGradientAddress.first = gradientAddress[0];
    ipfsGradientAddress.second = gradientAddress[1];

    IPFS memory newWeights;
    newWeights.first = 0;
    newWeights.second = 0;

    Gradient memory newGrad;
    newGrad.grads = ipfsGradientAddress;
    newGrad.from = msg.sender;
    newGrad.modelId = modelId;
    newGrad.newModelError = 0;
    newGrad.newWeights = newWeights;
    newGrad.evaluated = false;

    grads.push(newGrad);
  }

  function getNumModels() constant returns(uint256 modelCount) {
    return models.length;
  }

  function getNumGradientsforModel(uint modelId) constant returns (uint num) {
    num = 0;
    for (uint i = 0; i<grads.length; i++) {
      if (grads[i].modelId == modelId) {
        num += 1;
      }
    }
    return num;
  }

  function getGradient(uint modelId, uint gradientId) constant returns (uint, address, bytes32[], uint, bytes32[]) {
    uint num = 0;
    for (uint i = 0; i<grads.length; i++) {
      if (grads[i].modelId == modelId) {
        if (num == gradientId) {

          bytes32[] memory gradientAddress = new bytes32[](2);

          gradientAddress[0] = grads[i].grads.first;
          gradientAddress[1] = grads[i].grads.second;

          bytes32[] memory weightsAddress = new bytes32[](2);
          weightsAddress[0] = grads[i].newWeights.first;
          weightsAddress[1] = grads[i].newWeights.second;

          return (i, grads[i].from, gradientAddress, grads[i].newModelError, weightsAddress);
        }
        num += 1;
      }
    }
  }

  function getModel(uint modelId) constant returns (address,uint,uint,uint,bytes32[]) {
    Model memory currentModel;
    currentModel = models[modelId];
    bytes32[] memory weights = new bytes32[](2);

    weights[0] = currentModel.weights.first;
    weights[1] = currentModel.weights.second;

    return (currentModel.owner, currentModel.bounty, currentModel.initialError, currentModel.targetError, weights);
  }

}

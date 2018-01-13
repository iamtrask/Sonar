pragma solidity ^0.4.4;

contract ModelRepository {

  Model[] models;
  Gradient[] grads;

  // Structs

  struct IPFS {
    bytes32 first;
    bytes32 second;
  }

  struct Gradient {

    bool evaluated;

    // submitted from miner
    address from;
    IPFS grad;
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

  // Modifiers

  modifier onlyByModelOwner(uint gradientId) {
    require(msg.sender == models[grads[gradientId].modelId].owner);
    _;
  }

  modifier onlyIfGradientNotYetEvaluated(uint gradientId) {
    require(grads[gradientId].evaluated == false);
    _;
  }

  // Functions

  /// @dev Transfers currency from this contract to the receiver's address.
  /// @param receiver Address of receiver.
  /// @param amount Amount of currency to be transferred.
  function transferAmount(address receiver, uint amount) private {
    assert(receiver.send(amount));
  }

  /// @notice Adds a new model to the blockchain.
  /// @dev Model is associated to bounty and sender.
  /// @param weights Model's initial weights' IPFS address.
  /// @param initialError Model's initial error value.
  /// @param targetError Model's target error value.
  function addModel(bytes32[] weights, uint initialError, uint targetError) public payable {

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

  /// @notice Calculates the incentive to be payed to the miner based on the
  /// solved error, the model's bounty and the model's total error.
  /// @dev Incentive is calculated as a percentage of total error solved, times
  /// the total bounty.
  /// @param bounty Model's associated bounty.
  /// @param totalError Model's total error.
  /// @param solvedError Total error solved by miner.
  /// @return The calculated incentive.
  function calculateIncentive(uint bounty, uint totalError, uint solvedError) constant public returns(uint total) {
    return (bounty*solvedError) / totalError;
  }

  /// @notice Evaluates if gradient with given id, resulting error and weights.
  /// Then, decreases the model error and pays the miner accordingly.
  /// @dev Miner is payed only if model's best error hasn't reached targetError.
  /// @param gradientId Id of the gradient to be evaluated.
  /// @param newModelError New error of gradient to be evaluated.
  /// @param newWeightsAddress IPFS address of the new weights.
  function evalGradient(uint gradientId, uint newModelError, bytes32[] newWeightsAddress) onlyByModelOwner(gradientId) onlyIfGradientNotYetEvaluated(gradientId) public {
    grads[gradientId].newWeights.first = newWeightsAddress[0];
    grads[gradientId].newWeights.second = newWeightsAddress[1];
    grads[gradientId].newModelError = newModelError;

    Model model = models[grads[gradientId].modelId];
    if (newModelError < model.bestError && model.targetError < model.bestError) {
      uint totalError = model.initialError - model.targetError;
      uint solvedError = model.bestError - newModelError;

      uint incentive = calculateIncentive(model.bounty, totalError, solvedError);

      model.bestError = newModelError;
      model.weights = grads[gradientId].newWeights;
      transferAmount(grads[gradientId].from, incentive);
    }

    grads[gradientId].evaluated = true;
  }

  /// @notice Adds a new gradient to the blockchain.
  /// @dev Submitted gradient's new weights and new model error are set to
  /// zero.
  /// @param modelId Id of the model to which the new gradients correspond.
  /// @param gradientAddress IPFS address of the gradient being added.
  function addGradient(uint modelId, bytes32[] gradientAddress) public {
    require(models[modelId].owner != 0);
    IPFS memory ipfsGradientAddress;
    ipfsGradientAddress.first = gradientAddress[0];
    ipfsGradientAddress.second = gradientAddress[1];

    IPFS memory newWeights;
    newWeights.first = 0;
    newWeights.second = 0;

    Gradient memory newGrad;
    newGrad.grad = ipfsGradientAddress;
    newGrad.from = msg.sender;
    newGrad.modelId = modelId;
    newGrad.newModelError = 0;
    newGrad.newWeights = newWeights;
    newGrad.evaluated = false;

    grads.push(newGrad);
  }

  /// @notice Return the number of models stored in the blockchain.
  /// @return The number of models stored in the blockchain.
  function getNumModels() constant public returns(uint256 modelCount) {
    return models.length;
  }

  /// @notice Return the number of gradients in the blockchain for model with
  /// given id.
  /// @return The number of gradients in the blockchain for model with
  /// given id.
  function getNumGradientsforModel(uint modelId) constant public returns (uint num) {
    num = 0;
    for (uint i = 0; i<grads.length; i++) {
      if (grads[i].modelId == modelId) {
        num += 1;
      }
    }
    return num;
  }

  /// @notice Return the gradient with given id associated to model with given
  /// model id.
  /// @param modelId Id of model to be queried.
  /// @param gradientId Id of gradient for given model.
  /// @return The queried gradient as a tuple with form (index in array, from address, gradient address, gradient's new model error, gradient's weight address).
  function getGradient(uint modelId, uint gradientId) constant public returns (uint, address, bytes32[], uint, bytes32[]) {
    uint num = 0;
    for (uint i = 0; i<grads.length; i++) {
      if (grads[i].modelId == modelId) {
        if (num == gradientId) {

          bytes32[] memory gradientAddress = new bytes32[](2);

          gradientAddress[0] = grads[i].grad.first;
          gradientAddress[1] = grads[i].grad.second;

          bytes32[] memory weightsAddress = new bytes32[](2);
          weightsAddress[0] = grads[i].newWeights.first;
          weightsAddress[1] = grads[i].newWeights.second;

          return (i, grads[i].from, gradientAddress, grads[i].newModelError, weightsAddress);
        }
        num += 1;
      }
    }
  }

  /// @notice Return the model with given unique id.
  /// @param modelId Id of model to be retrieved.
  /// @return The model associated to the id, as a tuple with form (owner, bounty, initialError, targetError, weight address).
  function getModel(uint modelId) constant public returns (address,uint,uint,uint,bytes32[]) {
    Model memory currentModel;
    currentModel = models[modelId];
    bytes32[] memory weights = new bytes32[](2);

    weights[0] = currentModel.weights.first;
    weights[1] = currentModel.weights.second;

    return (currentModel.owner, currentModel.bounty, currentModel.initialError, currentModel.targetError, weights);
  }
}

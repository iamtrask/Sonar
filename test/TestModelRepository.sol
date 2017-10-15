pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ModelRepository.sol";

contract TestModelRepository {

  function testHoldsZeroModelsInitially() {
    ModelRepository repo = new ModelRepository();

    uint initialModelsAmount = 0;

    Assert.equal(repo.getNumModels(), initialModelsAmount, "ModelRepository holds 0 models initially");
  }
  
  function testIncentiveValue() {
    ModelRepository repo = new ModelRepository();

    uint bounty_1 = 10000;
    uint bounty_2 = 123456789;

    //total error = initial error - target_error
    uint totalError_1 = 2000;
    uint totalError_2 = 9;

    //solved error = best_error - _new_model_error
    uint solvedError_1 = 37;
    uint solvedError_2 = 4;

    uint solutionValue_1 = 185;
    uint solutionValue_2 = 54869684;

    Assert.equal(repo.calculateIncentive(bounty_1, totalError_1, solvedError_1), solutionValue_1, "calculateIncentive 1");
    Assert.equal(repo.calculateIncentive(bounty_2, totalError_2, solvedError_2), solutionValue_2, "calculateIncentive 2");
  }
}

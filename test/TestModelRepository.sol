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

    //total error = initial error - target_error
    //solved error = best_error - _new_model_error
    //incentiveCalculate(bounty, total_error, solved_error)

    Assert.equal(repo.incentiveCalculate(3000000000000000000, 500, 10), 60000000000000000, "test case 1 success");
    Assert.equal(repo.incentiveCalculate(123456789, 12, 4), 41152263, "test case 2 success");
  }
}

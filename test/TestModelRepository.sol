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

}

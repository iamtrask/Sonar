# Sonar

[![Chat on Slack](https://img.shields.io/badge/chat-on%20slack-7A5979.svg)](https://openmined.slack.com/)
[![Build Status](https://travis-ci.org/OpenMined/Sonar.svg?branch=master)](https://travis-ci.org/OpenMined/Sonar)

Sonar observes all models being trained and ensures that occuppation occurs fairly.
It’s a smart contract running on an [Ethereum](https://ethereum.org/) Blockchain that holds bounties and stores pointers to AI models on [IPFS](https://ipfs.io/).

## Using Docker

We prepared a Docker container of the Sonar smart contract running on a private in-memory ethereum blockchain ([testrpc](https://github.com/ethereumjs/testrpc)).

Run

```sh
docker run -d -p 8545:8545 openmined/sonar-testrpc:edge
# :edge for the latest dev build
# :latest (default) for stable builds
```

Everytime you restart the docker container all interactions to the chain will be reset and you will have a clean image (with nothing but the contract).

### Docker creation

There are two docker files in this repository. `Dockerfile` creates a plain Sonar container ([openmined/sonar](https://hub.docker.com/r/openmined/sonar
)) with the compiled contract in it. `Dockerfile.testrpc` creates the [openmined/sonar-testrpc](https://hub.docker.com/r/openmined/sonar-testrpc) image with the contract pre-deployed on `testrpc`.

## Manual setup

### Linux / OS X

Install dependencies

```npm install```

Start testrpc

```
./node_modules/.bin/testrpc
```

Compile and deploy the contracts

```
npm run deploy
```

Make sure everything works

```
npm run test
```

### Windows 10

On Windows, you will have to take a few extra steps to get everything to work locally:

* Make sure that the Solidity source files in `contracts/` (and `test/`) have Unix-Style line endings (`LF`).
One way to do this is enabling Unix-Style checkout for the project:
```
git config core.autocrlf input
git fetch --all
```
If this causes problems for you, edit the `.sol` files manually.

* Rename `truffle.js` to `truffle-config.js`.

* In `package.json` change the line that starts with `extract-abi`. Add `node` before the path of the script, i.e. the line should read
```
"extract-abi": "node ./bin/extract-abi build/contracts/ModelRepository.json > build/ModelRepository.abi"
```

Finally, follow the Linux instructions above.
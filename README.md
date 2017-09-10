# Sonar

[![Chat on Slack](https://img.shields.io/badge/chat-on%20slack-7A5979.svg)](https://openmined.slack.com/)
[![Build Status](https://travis-ci.org/OpenMined/Sonar.svg?branch=master)](https://travis-ci.org/OpenMined/Sonar)

> Decentralized Machine Learning Server (via Blockchain)

## Docker

https://hub.docker.com/r/openmined/sonar/

We prepared a dockerized version of the Sonar smart contract already running on `testrpc`. To start it just run

```sh
docker run -d -p 8545:8545 openmined/sonar-testrpc:edge
# :edge for the latest dev build
# :latest (default) for stable builds
```

The current contract address in this image is `0xdde11dad6a87e03818aea3fde7b790b644353ccc` 
In addition there are `42` bootstrapped accounts with `100 ETH` each.

Everytime you restart the docker container all interactions to the chain will be reset and you will have a clean image (with nothinb but the contract).

### Docker creation

There are two docker files in this repository. `Dockerfile` creates a plain Sonar container ([openmined/sonar](https://hub.docker.com/r/openmined/sonar
)) with just the compiled contract in it. `Dockerfile.testrpc` creates the [openmined/sonar-testrpc](https://hub.docker.com/r/openmined/sonar-testrpc) image with the contract pre-deployed on `testrpc`.

## Manual setup

### Install dependencies

```npm install```

### compile and deploy local libraries

First you need to start the testrpc
```
# run local ethereum mock
testrpc -a 1000
```

Then, compile the contracts and load them onto the blockchain.
```
npm run deploy
```

You should see output like:

```sh
Using network 'development'.
Running migration: 1_initial_migration.js
  Deploying Migrations...
  Migrations: 0xf06039885460a42dcc8db5b285bb925c55fbaeae
Saving successful migration to network...
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying ConvertLib...
  ConvertLib: 0x6cc86f0a80180a491f66687243376fde45459436
  Deploying ModelRepository...
  ModelRepository: 0xe26d32efe1c573c9f81d68aa823dcf5ff3356946
  Linking ConvertLib to MetaCoin
  Deploying MetaCoin...
  MetaCoin: 0x6d3692bb28afa0eb37d364c4a5278807801a95c5
Saving successful migration to network...
Saving artifacts...
```

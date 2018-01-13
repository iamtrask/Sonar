# Sonar

[![Chat on Slack](https://img.shields.io/badge/chat-on%20slack-7A5979.svg)](https://openmined.slack.com/)
[![Build Status](https://travis-ci.org/OpenMined/Sonar.svg?branch=master)](https://travis-ci.org/OpenMined/Sonar)

Sonar observes all models being trained and ensures that occuppation occurs fairly.
It’s a smart contract running on an [Ethereum](https://ethereum.org/) Blockchain that holds bounties and stores pointers to AI models on [IPFS](https://ipfs.io/).

## Using Docker

We prepared a Docker container of the Sonar smart contract running on a private in-memory ethereum blockchain.

Run

```sh
docker run -d -p 8545:8545 openmined/sonar:edge
# :edge for the latest dev build
# :latest (default) for stable builds
```

Everytime you restart the docker container all interactions to the chain will be reset and you will have a clean image (with nothing but the contract).

## Local installation

##### Get the repo

```sh
git clone git@github.com:OpenMined/Sonar.git
cd Sonar
npm install
```

##### Start the development environment
Sonar uses [truffle develop](http://truffleframework.com/docs/getting_started/client#truffle-develop) built in environment on `http://127.0.0.1:9545`. It will display the first 10 accounts and the mnemonic used to create those accounts. 

```
npm run develop
```


##### Deploy contracts
In a new tab, compile and deploy the contracts

```
npm run migrate
```

##### Test

```
npm test
```

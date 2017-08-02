# Sonar

> Federated Deep Learning on the Ethereum Blockchain

<!-- TOC depthFrom:2 -->

- [installation](#installation)
    - [truffle](#truffle)
    - [ipfs](#ipfs)
    - [build local libraries](#build-local-libraries)
- [usage](#usage)
- [known issues](#known-issues)

<!-- /TOC -->

### truffle

Truffle is required to compile the contracts in this repo:
```npm install -g truffle```

### ipfs

As the network itself is too big to actually host it on the blockchain you need `IPFS` to host the files.
For installation see the [ipfs installation page](https://dist.ipfs.io/#go-ipfs) or run 

```sh
brew install ipfs
```

After installation is complete run `ipfs init` to initialize your local IPFS system.


### compile and deploy local libraries

First you need to start the testrpc
```# run local ethereum mock
testrpc -a 1000
```

Then, compile the contracts and load them onto the blockchain.
```
truffle compile
truffle migrate
```

You should see output like:

```Using network 'development'.

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

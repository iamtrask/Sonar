# Sonar

[![Chat on Slack](https://img.shields.io/badge/chat-on%20slack-7A5979.svg)](https://openmined.slack.com/)
[![Build Status](https://travis-ci.org/OpenMined/Sonar.svg?branch=master)](https://travis-ci.org/OpenMined/Sonar)

> Decentralized Machine Learning Server (via Blockchain)

## Installation

### Binary Distribution
This installation involves the downloading of the binaries and subsequently moving them into your $PATH.

Download the [binaries](https://github.com/tendermint/ethermint/releases/tag/v0.2.2) for your platform on the release page. Open a terminal window and switch into the folder that you downloaded ethermint to.

```bash
unzip -d /usr/local/bin ${the name of the ethermint binary}.zip 
```

### Source
Ethermint builds with go1.8.3 and hence go1.8.3 needs to be installed. In order to manage your go installation we recommend [GVM](https://github.com/moovweb/gvm).

Once go is installed and configured you can download ethermint.
```bash
go get -u -d github.com/tendermint/ethermint
```
This places the ethermint source code into the appropriate directory in your $GOPATH.

Next you need to switch into the ethermint directory and install it.
```bash
cd $GOPATH/src/github.com/tendermint/ethermint

make install
```
This will download all the necessary dependencies and install ethermint in your $PATH.




## Starting Ethermint

### Tendermint
Ethermint relies on the [Tendermint](https://github.com/tendermint/tendermint) executable to provide the networking and consensus engines.

```bash
go get -u -d github.com/tendermint/tendermint

cd $GOPATH/src/github.com/tendermint/tendermint

make install
```
This will download all the necessary dependencies and install tendermint in your $PATH.

### Initialisation
To get started, you need to initialise the genesis block for tendermint core and go-ethereum. We provide initialisation
files with reasonable defaults and money allocated into a predefined account. If you installed from binary or docker
please download these default files [here](https://github.com/tendermint/ethermint/tree/develop/setup).

You can choose where to store the ethermint files with `--datadir`. For this guide, we will use `~/.ethermint`, which is a reasonable default in most cases.

Before you can run ethermint you need to initialise tendermint and ethermint with their respective genesis states.
Please switch into the folder where you have the initialisation files. If you installed from source you can just follow
these instructions.
```bash
tendermint init --home ~/.ethermint/tendermint

cd $GOPATH/src/github.com/tendermint/ethermint

ethermint --datadir ~/.ethermint init setup/genesis.json

cp -r setup/keystore ~/.ethermint
```
In the last step we copy the private key from the initialisation folder into the actual ethereum folder. 

### Running
To execute ethermint we need to start two processes. The first one is for tendermint, which handles the P2P
communication as well as the consensus process, while the second one is actually ethermint, which provides the
go-ethereum functionality.

```bash
tendermint --home ~/.ethermint/tendermint node

ethermint --datadir ~/.ethermint --rpc --rpcaddr=0.0.0.0 --ws --wsaddr=0.0.0.0 --rpcapi eth,net,web3,personal,admin
```

The **password** for the default account is *1234*.


----

## Connecting to Ethermint
Ethermint is fully compatible with the standard go-ethereum tooling such as [geth](https://github.com/ethereum/go-ethereum/wiki/Geth), [mist](https://github.com/ethereum/mist) and [truffle](https://github.com/trufflesuite/truffle). Please
install whichever tooling suits you best. 

Below we are explaining how to connect these tools to ethermint. For installation instructions please visit the respective projects.

### Geth

```bash
geth attach http://localhost:8545
```
This will drop you into a web3 console.

### Truffle
Truffle works without any extra arguments.

## Installation

Let's compile the contracts and load them onto the blockchain !!

```bash
truffle migrate
```
You should see output like:

```bash
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
And you're off!

----

# Sonar

[![Chat on Slack](https://img.shields.io/badge/chat-on%20slack-7A5979.svg)](https://openmined.slack.com/)
[![Build Status](https://travis-ci.org/OpenMined/Sonar.svg?branch=master)](https://travis-ci.org/OpenMined/Sonar)

> Decentralized Machine Learning Server (via Blockchain)

## Manual setup

## [Ethermint](https://github.com/tendermint/ethermint)
### Ethereum powered by Tendermint consensus

### [Download the latest release](https://github.com/tendermint/ethermint/releases/tag/v0.2.2)

[![GitHub release](https://img.shields.io/badge/release-latest-blue.svg)]() [![](https://circleci.com/gh/tendermint/ethermint/tree/master.svg?style=shield)](https://circleci.com/gh/tendermint/ethermint/tree/master) [![](https://tokei.rs/b1/github/tendermint/ethermint)](https://github.com/tendermint/ethermint) [![](https://img.shields.io/badge/go-1.8-blue.svg)](https://github.com/moovweb/gvm) [![](https://img.shields.io/badge/issues-7-yellow.svg)](https://github.com/tendermint/ethermint/issues) [![License](https://img.shields.io/badge/license-GPLv3.0%2B-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

### Documentation
We are using `godoc` for our documentation. In order to browse the [interactive documentation](http://localhost:6060/pkg/github.com/tendermint/ethermint/) please open a terminal window and navigate
to the ethermint folder and run godoc.
```bash
cd $GOPATH/src/github.com/tendermint/ethermint

godoc -http :6060
```

----

## About Ethermint

Ethermint enables ethereum to run as an [ABCI](https://github.com/tendermint/abci) application on tendermint and the COSMOS hub. This application allows you to get all the benefits of ethereum without having to run your own miners.

This means running an Ethereum EVM-based network that uses Tendermint consensus instead of proof-of-work.
The way it's built makes it easy to use existing Ethereum tools (geth attach, web3) to interact with the node.


----


## Installation

### Binary Distribution
This installation involves the downloading of the binaries and subsequently moving them into your $PATH.

Download the [binaries](https://github.com/tendermint/ethermint/releases/tag/v0.2.2) for your platform on the release page. Open a terminal window and switch into the folder that you downloaded ethermint to.

```bash
unzip -d /usr/local/bin ${the name of the ethermint binary}.zip 
```

### Docker
We are currently building docker images for both [ethermint](https://hub.docker.com/r/adrianbrink/ethermint/) and [tendermint](https://hub.docker.com/r/adrianbrink/tendermint/). There are images for versioned releases, builds of master and builds of develop.

// TODO: Add example of how to get a node up and running using docker

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


### Tendermint
Ethermint relies on the [Tendermint](https://github.com/tendermint/tendermint) executable to provide the networking and consensus engines.

```bash
go get -u -d github.com/tendermint/tendermint

cd $GOPATH/src/github.com/tendermint/tendermint

make install
```
This will download all the necessary dependencies and install tendermint in your $PATH.


----

## Starting Ethermint

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
truffle deploy
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

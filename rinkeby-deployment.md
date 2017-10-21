# Deploying Sonar to Rinkeby testnet 📦⛓

<!-- TOC depthFrom:2 -->

- [⚙ prerequisites](#⚙-prerequisites)
- [🚀 deploying sonar](#-deploying-sonar)
    - [1. start local geth node](#1-start-local-geth-node)
    - [2. create your account](#2-create-your-account)
    - [3. fund your account](#3-fund-your-account)
    - [4. deploy using truffle](#4-deploy-using-truffle)
        - [truffle config](#truffle-config)
        - [run local rinkeby node with the unlocked account](#run-local-rinkeby-node-with-the-unlocked-account)
        - [do the actual deployment](#do-the-actual-deployment)
- [📞 Using the deployed contract](#-using-the-deployed-contract)
    - [start local geth node](#start-local-geth-node)

<!-- /TOC -->

> We will use the OpenMined Sonar smartcontract deployed to the rinkeby ethereum testchain.

**Note**: This is the first hacky docs for what I did to deploy the contract and attach to it. Feel free to improve this doc!

All paths are MacOS specific.. might differ for you

## ⚙ prerequisites

First you need to install [geth](https://geth.ethereum.org/) for running a local ethereum node

## 🚀 deploying sonar

what's going to happen:
1. start local rinkeby node
1. create account on local node
1. fund your account
1. deploy sonar using truffle
1. verify the contract is there

### 1. start local geth node

`geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal` 

### 2. create your account

_Creating the account using `geth account new` didn't work for me as it seems that the account is created for the main net and importing the account to testnet is not possible. Might be able to pull this off by moving files around._

You attach to the `geth` with a REPL: `geth attach ~/Library/Ethereum/rinkeby/geth.ipc`

If you type `eth.accounts` you should get an empty response `[]`

Just call `personal.newAccount()` and enter a passphrase (or leave it empty #yolo). However you should not forget it. This is NOT your private key!

You will get a respons showing you your new account similar to:

```
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0xbf4696ecfa2d3697f98805d4166fdaeaf3b67944"
```

Your private key is stored in a secret facility (`~/Library/Ethereum/rinkeby/keystore`). If you wish to view your account on [myetherwallet](https://www.myetherwallet.com/#view-wallet-info) just select the option of `Keystore File (UTC / JSON)` and point it to the file at this address. Enter your passphrase and you should see your account.

### 3. fund your account

Now that you have an address head over to [rinkeby faucet](https://www.rinkeby.io/) to fund it. Follow any of the mentioned methods there to get some money into your account. I suggest starting with the lowest amount since it only blocks you for 8hours in case you fuck anything up you can retry later with a new account.

You will need funds in order to deploy the contract! For me it was [~0.14ETH](https://rinkeby.etherscan.io/address/0xbf4696ecfa2d3697f98805d4166fdaeaf3b67944)

### 4. deploy using truffle

#### truffle config
Open the `truffle.js` in the `OpenMined/sonar` respository and add **rinkeby** as a network:

```
,
rinkeby: {
    host: "localhost", // Connect to geth on the specified
    port: 8545,
    from: "0xbf4696ecfa2d3697f98805d4166fdaeaf3b67944", // default address to use for any transaction Truffle makes during migrations
    network_id: 4,
    gas: 4612388 // Gas limit used for deploys
}
```

Make sure to change `from` to your address.

#### run local rinkeby node with the unlocked account

Now we need to restart `geth` with the `--unlock` option because otherwise we can not sign and send transaction from our newly created account.
Close the previous `geth` and the attached REPL if you havent already.

This time we will start `geth` with the following command (change your address):

```
geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0xbf4696ecfa2d3697f98805d4166fdaeaf3b67944"
```

#### do the actual deployment

Run truffle and you should see the following output

```
▶ truffle migrate --network rinkeby
Using network 'rinkeby'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0xab58fba266ec5aa47af521c645d9262e925cc5e0dc1e8489e7b1d45368317cef
  Migrations: 0x112b5c472f106385525e70cfd1f2eaf4e7682124
Saving successful migration to network...
  ... 0x7e1a0d6ea35c496dd043fe7d43a29153307b7755ec435160d872cae6e0b1d19a
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying ModelRepository...
  ... 0xfa6c166e07fad39316d68b8b3dcee340886cdeda8ac5f36b755ec24932bc9ea4
  ModelRepository: 0xd60e1a150b59a89a8e6e6ff2c03ffb6cb4096205
Saving successful migration to network...
  ... 0x1ead7f3077388bba543f2f713cddac0be028dd016d9cb03eedf46c7a4b43a4d7
Saving artifacts...
```

As you can see we have a new contract deployed at `0xd60e1a150b59a89a8e6e6ff2c03ffb6cb4096205` you can verify this by heading over to [etherscan](https://rinkeby.etherscan.io/address/0xd60e1a150b59a89a8e6e6ff2c03ffb6cb4096205) and see your contract.

## 📞 Using the deployed contract

To connect to the smartcontract on rinkeby you need to run the local `geth` node.

You might need an account for that so please refer to the instructions above.

### start local geth node

Change the unlock address to the account you want to use to interact with the contract

```
geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0xbf4696ecfa2d3697f98805d4166fdaeaf3b67943"
```

With this you should be able to point `pySonar` or `mine.js` to this `localhost:8545` as if it were a testrpc instance.

The first deployment is at the contract address `0xd60e1a150b59a89a8e6e6ff2c03ffb6cb4096205`

_Good luck, take this ⚔_

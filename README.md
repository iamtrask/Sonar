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


### build local libraries

First you need to get `solar` package bundled up

```sh
python setup.py install
```

Then make sure you also have the [`syft`](https://github.com/OpenMined/syft) package properly installed. Head over to the repository and follow its instructions.

# HowTo use docker on Sonar

> Bundle Sonar contract into a testrpc docker image 🐳📦

## Overview

To ease development and onboarding the `Sonar` contract is shipped pre-deployed into a custom [testrpc](https://github.com/ethereumjs/testrpc) docker container. This allows usage of the contract without the ned to manually deploy it to testrpc after every start.

Docker images should be automatically build and tagged for every `master` commit.

## Building an image

To build the image we first need to create a `testrpc` database with the contract deployed in it. The [init_testrpc.sh](init_testrpc.sh) shell script should take care of that. Otherwise the [Dockerfile](Dockerfile) can be bundle the database that was stored at `build/testrpc_test`.

For local builds:

```sh
sh init_testrpc.sh
docker build -t sonar-testrpc -f Dockerfile.testrpc .
```

#!/bin/sh
# this script initializes a testrpc database with the sonar contract and a bunch of addresses
# requires a node runtime
set -e

RPC_FOLDER="data/testrpc_persist"

# make sure testrpc starts with an empty data directory
rm -rf ${RPC_FOLDER} && mkdir -p ${RPC_FOLDER}

# install testrpc 
echo "Installing node dependencies.."
npm i ethereumjs-testrpc truffle > /dev/null

# start testrpc
echo "Starting testrpc.."
node_modules/.bin/testrpc --db ${RPC_FOLDER} --accounts 42 --seed 20170812 > /dev/null & 
PID_RPC=$!
sleep 3 # wait for testrpc to fully start

# compile contract
echo "Compile Sonar contract.."
node_modules/.bin/truffle compile > /dev/null

echo "Deploy contract to testrpc.."
# TODO: Figure out how to grep/awk the modelrepository from here..
truffle migrate

echo "Cleanup.."
kill $PID_RPC

echo "Done!"

#!/bin/bash

# SPINNER FUNCTIONS

spinnerChar="⠁⠂⠄⡀⢀⠠⠐⠈"
spinnerIndex=0
spinnerSTART() {
  printf "\b${spinnerChar:spinnerIndex++:1}"
  ((spinnerIndex == ${#spinnerChar})) && spinnerIndex=0
}
spinnerSTOP() {
  printf "\r%s\n" "$@"
}
if [ -f ./contracts/.env ]; then
  source ./contracts/.env
else
  echo "Please add a .env inside the contracts folder."
  exit 1
fi

DEPLOYMENT_ARTIFACT=uad-contracts-deployment.json

rm -f ./frontend/src/$DEPLOYMENT_ARTIFACT
mkdir -p  ./frontend/src
yarn stop # kill blockchain
cd ./contracts || echo "ERROR: ./contracts/ doesn't exist?"
yarn
export TS_NODE_TRANSPILE_ONLY=1 && yarn hardhat compile &>../hardhat-compile.log 2>&1 &
yarn hardhat node --fork https://eth-mainnet.alchemyapi.io/v2/"$ALCHEMY_API_KEY" --fork-block-number 12150000 --show-accounts --export-all tmp-$DEPLOYMENT_ARTIFACT >../local.node.log 2>&1 &
echo "Pausing until $DEPLOYMENT_ARTIFACT exists."
while :; do
  spinnerSTART
  [[ -f "tmp-$DEPLOYMENT_ARTIFACT" ]] && break
  sleep .06
done
spinnerSTOP
node ../hooks/process-deployment.js ./tmp-$DEPLOYMENT_ARTIFACT ../frontend/src/$DEPLOYMENT_ARTIFACT
rm -f ./tmp-$DEPLOYMENT_ARTIFACT
cd ..
mkdir -p
exit 0

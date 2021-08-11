#!/bin/bash

cd $(pwd)/../contracts/ || exit
echo "✅ --- 0 ---"
yarn
echo "✅ --- 1 ---"
yarn add hardhat
echo "✅ --- 2 ---"
export TS_NODE_TRANSPILE_ONLY=1 && yarn hardhat compile
echo "✅ --- 3 ---"
cp -r $(pwd)/artifacts/types $(pwd)/src/
echo "✅ --- 4 ---"
cd $(pwd)/../frontend/ || exit
echo "✅ --- 5 ---"
yarn
echo "✅ --- 6 ---"
next build
echo "✅ --- 7 ---"
yarn next start
echo "✅ --- 8 ---"

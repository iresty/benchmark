#!/usr/bin/env bash

set -ex

for var in {1..1000}
do
     ./generate-routes.lua 1 50 172.24.225.27
     echo "times: $var"
     sleep 1
done

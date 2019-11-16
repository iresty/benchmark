#!/bin/bash

set -ex

./reset-gateway.sh

./generate-routes.sh 20 100 127.0.0.1 127.0.0.2

wrk -s ../wrk/request-20svr-100uri.lua -t 6 -c 48 -d 20 http://127.0.0.1:9080/mmmm

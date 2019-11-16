#!/bin/bash

set -ex

./reset-gateway.sh

./generate-routes.lua 10 1000 127.0.0.1

sleep 1

curl http://127.0.0.1:9080/service_99/uri_10

sleep 1

wrk -s ../wrk/request-100svr-10uri.lua -t 6 -c 48 -d 20 \
    http://127.0.0.1:9080/mmmm

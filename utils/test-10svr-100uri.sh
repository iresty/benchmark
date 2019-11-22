#!/usr/bin/env bash

set -ex

./reset-gateway.sh

./generate-routes.lua 10 100 $@

sleep 1

curl http://172.24.225.28:9080/service_99/uri_10

sleep 1

wrk -s ../wrk/request-100svr-10uri.lua -t 6 -c 48 -d 20 \
    http://172.24.225.28:9080/mmmm

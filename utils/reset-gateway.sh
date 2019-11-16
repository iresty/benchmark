#!/usr/bin/env bash

set -ex

cd ../../apisix
make stop

etcdctl rm -r /apisix

make init

sed  -i "s/worker_processes auto/worker_processes 8/g" conf/nginx.conf

make run

sleep 1

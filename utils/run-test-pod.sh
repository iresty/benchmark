#!/usr/bin/env bash

#
docker stop $(docker ps -a -q)

pod_count=$1
if [ ! $pod_count ]; then
    pod_count=10
fi

base_port=200
for((i=$base_port+1; i<=$base_port+$pod_count; i++));
do
    docker run -d --name pod$i --rm -p $i:80  -v $PWD/nginx.conf:/etc/openresty/nginx.conf openresty/openresty
done

# docker stop $(docker ps -a -q)

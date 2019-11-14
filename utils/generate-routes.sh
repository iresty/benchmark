#!/bin/sh

# set -ex

# etcdctl rm -r /apisix
# cd ../apisix && make init && cd ../benchmark

service_count=$1
if [ ! $service_count ]; then
    service_count=10
fi
uri_count=$2
if [ ! $uri_count ]; then
    uri_count=10
fi

for((i=1; i<=$service_count; i++));
do
    for((j=1; j<=$uri_count; j++));
    do
        body='{
            "uri": "/service_1/uri_1",
            "plugins": {
                "proxy_rewrite": {
                    "uri": "/uri_1"
                }
            },
            "upstream": {
                "type": "roundrobin",
                "nodes": {
                    "39.97.63.215:80": 1
                }
            }
        }'

        # echo "$body" | sed "s|/service_1/uri_1|/service_1/uri_2|"
        body=${body/service_1/service_$i}
        body=${body/uri_1/uri_$j}
        body=${body/uri_1/uri_$j}
        body=${body/215:80/215:80$j}

        echo curl -i http://127.0.0.1:9080/apisix/admin/routes/$i -X PUT -d "$body"
        curl -i http://127.0.0.1:9080/apisix/admin/routes/$i -X PUT -d "$body"

        echo ''
        echo ''
        echo ''
    done
done

echo "service count: $service_count"
echo "uri     count: $uri_count"
echo "upstream count: $uri_count"

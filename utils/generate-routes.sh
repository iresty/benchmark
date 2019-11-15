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

id=1
for((i=1; i<=$service_count; i++));
do
    for((j=1; j<=$uri_count; j++));
    do
        body='{
            "uri": "/service_x/uri_x",
            "plugins": {
                "proxy-rewrite": {
                    "uri": "/uri_x"
                }
            },
            "upstream": {
                "type": "roundrobin",
                "nodes": {
                    "172.26.36.52:xx": 1
                }
            }
        }'

        # echo "$body" | sed "s|/service_1/uri_1|/service_1/uri_2|"
        body=${body/service_x/service_$i}
        body=${body/uri_x/uri_$j}
        body=${body/uri_x/uri_$j}

	port=`expr 80 + $j`
        body=${body/:xx/:$port}

        id=`expr $id + 1`
	echo curl -i http://127.0.0.1:9080/apisix/admin/routes/$id -X PUT -d "$body"
        curl -i http://127.0.0.1:9080/apisix/admin/routes/$id -X PUT -d "$body"

        echo ''
        echo ''
        echo ''
    done
done

echo "service count: $service_count"
echo "uri     count: $uri_count"
echo "upstream count: $uri_count"

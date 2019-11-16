#!/usr/bin/env resty

local rsfile = io.popen([[lua -e 'print(package.path)']])
local lua_path = rsfile:read("*all")
ngx.say(lua_path)
rsfile:close()

package.path = lua_path .. ";" .. package.path

local http = require("resty.http")
local json = require("cjson.safe")

local service_count = arg[1] or 10
local up_count = arg[2] or 10
local upstreams = {arg[3] or "127.0.0.1"}
upstreams[2] = arg[4] or upstreams[1]

for i = 1, service_count do
    for j = 1, up_count do
        local idx = j % 2 + 1
        local body = {
            uri = "/service_" .. i .. "/uri_" .. j,
            plugins = {
                ["proxy-rewrite"] = {
                    uri = "/uri_" .. up_count
                }
            },
            upstream = {
                type = "roundrobin",
                nodes = {
                    [upstreams[idx] .. ":" .. (200 + i)] = 1
                }
            }
        }

        body = json.encode(body)

        local httpc = http.new()
        local res, err = httpc:request_uri("http://127.0.0.1:9080/apisix/admin/routes", {
            method = "POST",
            body = body,
            keepalive_pool = 10
        })

        if not res then
            ngx.say("failed to request: ", err)
            return
        end

        ngx.say("code: ", res.status, " body:", res.body)
    end
end

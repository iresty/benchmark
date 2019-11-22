local math_random = math.random
local wrk_format = wrk.format
local open = io.open

do
    local frandom, err = open("/dev/urandom", "rb")
    if not frandom then
        return nil, 'failed to open /dev/urandom: ' .. err
    end

    local str = frandom:read(4)
    frandom:close()
    if not str then
        return nil, 'failed to read data from /dev/urandom'
    end

    local seed = 0
    for i = 1, 4 do
        seed = 256 * seed + str:byte(i)
    end
    math.randomseed(seed)
end --do

local service_id = 0
local uri_id = 0

function request()
    service_id = service_id % 20
    uri_id = uri_id % 50
    service_id = service_id + 1
    uri_id = uri_id + 1
    
    local url = "/service_" .. service_id .. "/uri_" .. uri_id
    local header = nil
    local body = nil

    return wrk_format("GET", url, header, body)
end

local redisClient = require "redis"
local conn

local function makeConn() 

    local host = "127.0.0.1"
    local port = 6379

    KSR.info("Redis attempt to connect to "..host..":"..port.."\n")
 
    if conn then
        local res = conn:ping()
        if res then
            return conn
        end
    end
    
    status,conn = pcall(redisClient.connect,host,port)
    
    if status then
        return conn
    end

    KSR.err("Can't connect to redis server: "..conn.."\n")
    conn = nil

end

return {
    getConn = makeConn
}
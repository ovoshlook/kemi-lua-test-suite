return {
    redis_create_connection_failure = {
        description = "emulates connecton failure",
        testedModule = "redisClient.lua",
        testedFunction = "getConn",
        expectedResult = false,
        withParams = {
            internalLogging = true
        },
        mocks = {
            { 
                module = "redis.lua",
                target = "connect",
                replacer = function() 
                    print("redis mock connection failure result")
                    return false 
                end
                
            }
        }
    },
    redis_existing_connection_success = {
        description = "emulates connecton successed",
        testedModule = "redisClient.lua",
        testedFunction = "getConn",
        expectedResult = true,
        withParams = {
            internalLogging = true,
        },
        mocks = {
            {
                module = "redis.lua",
                target = "connect",
                replacer = function() 
                    print("redis mock connection success result")
                    return true 
                end
            }
        }
    }
}
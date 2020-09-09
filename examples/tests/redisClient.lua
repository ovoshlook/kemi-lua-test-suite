return {
    redis_create_connection_failure = {
        description = "connecton failure",
        testedModule = "redisClient.lua",
        testedFunction = "getConn",
        expectedResult = false,
        withParams = {
            internalLogging = true
        },
        mocks = {
            { 
                what = {"_G","redis","connect"},
                to = function() return false end
            }
        }
    },
    redis_existing_connection_success = {
        description = "connecton successed",
        testedModule = "redisClient.lua",
        testedFunction = "getConn",
        expectedResult = true,
        withParams = {
            internalLogging = true,
        },
        mocks = {
            { 
                what = {"_G","redis","connect"},
                to = function() return true end
            }
        }
    }
}
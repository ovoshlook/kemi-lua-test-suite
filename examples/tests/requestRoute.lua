return {

    request_route_call_1 = {
        description = "tests http_client response",
        testedFunction = "ksr_request_route",
        expectedResult = "test message",
        resultContainer = { "$avp", "body" },
        withParams = {
            internalLogging = true,
            ["$si"] = "1.2.3.4",
        },
        mocks = {
            {
                module = "KSR.http_client",
                target = "query" ,
                replacer = function(url,res) 
                    KSR.pv.seti("$rc",200) 
                    KSR.pv.sets(res,"test message")
                end
            }
        }
    },

    nested_module_calling = {
        description = "tests nested module",
        testedFunction = "global_test_route",
        testedResult = "original nested module test",
        withParams = {
            internalLogging = true,
        },
    },

    nested_module_mocking = {
        description = "tests nested module replacement",
        testedFunction = "global_test_route",
        testedResult = "replaced nested module test",
        mocks = {
            {
                module = "nested/subnested/test.lua",
                target = "testFunc" ,
                replacer = function() 
                    return "replaced nested module test"
                end
            }
        }
    },
}

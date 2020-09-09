return {

    request_route_call_2 = {
        description = "test http_client response",
        testedFunction = "ksr_request_route",
        expectedResult = "test message",
        resultContainer = { "$avp", "body" },
        withParams = {
            internalLogging = true,
            si = "1.2.3.4",
        },
        mocks = {
            {
                what = { "KSR","http_client","query" },
                to = function(url,res) 
                    KSR.pv.seti("$rc",200) 
                    KSR.pv.sets(res,"test message")
                end
            }
        }
    },

}

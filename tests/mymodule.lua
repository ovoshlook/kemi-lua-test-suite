local mymodule = {
    
    mymodule_call_testfunction1 = {
        description = "calls function and shows log message",
        testedFunction = kamailio.mymodule.testfunction1,
        withParams = {
            internalLogging = true
        }
    },

    mymodule_call_testfunction2 = {
        description = "returns table value",
        testedFunction = kamailio.mymodule.testfunction2,
        expectedResult = { a=1, b=2 }  
    },
}

return mymodule
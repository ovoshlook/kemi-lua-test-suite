local mymodule = {
    
    mymodule_call_testfunction1 = {
        description = "calls function and shows log message",
        testedModule = "mymodule.lua",
        testedFunction = "testfunction1",
        withParams = {
            internalLogging = true
        }
    },

    mymodule_call_testfunction2 = {
        description = "returns table value",
        testedModule = "mymodule.lua",
        testedFunction = "testfunction2",
        expectedResult = { "bla", { b=2, a=1 }}, 
        withParams = {
            internalLogging = true
        }
    },
}

return mymodule
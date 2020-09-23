return {
    is_OPTIONS_success = {
        description = "tests core is_METHODNAME function for OPTIONS",
        testedModule = "is_method.lua",
        testedFunction = "checkOptions",
        expectedResult = true, 
        withParams = {
            ["$rm"] = "OPTIONS",
            internalLogging = true
        }
    },
    is_INVITE_failure = {
        description = "tests core is_METHODNAME function for INVITE",
        testedModule = "is_method.lua",
        testedFunction = "checkInvite",
        expectedResult = false, 
        withParams = {
            ["$rm"] = "OPTIONS",
            internalLogging = true
        }
    }
}
return {
    add_header = {
        description = "adds header TEST",
        testedModule = "hdrUsage.lua",
        testedFunction = "addHeader",
        expectedResult = "data",
        resultContainer = { "$hdr", "TEST" },
        -- withParams = {
        --     internalLogging = true,
        --     si = "1.2.3.4",
        -- },
    },
    remove_header = {
        description = "removes header TEST2",
        testedModule = "hdrUsage.lua",
        testedFunction = "removeHeader",
        expectedResult = nil,
        resultContainer = { "$hdr", "TEST2" },
        withParams = {
            hdr = {
                TEST = data
            }
        },
    },
}
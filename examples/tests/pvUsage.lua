return {
    test_vp_sets_success = {
        description = "sets pv success",
        testedModule = "pvUsage.lua",
        testedFunction = "testFunction1",
        expectedResult = "test string",
        resultContainer = {"$avp","test"},
        withParams = {
            internalLogging = true
        }
    },
    test_vp_getvs_success = {
        description = "sets pv success",
        testedModule = "pvUsage.lua",
        testedFunction = "testFunction2",
        expectedResult = "default string",
        withParams = {
            internalLogging = true
        }
    }
}
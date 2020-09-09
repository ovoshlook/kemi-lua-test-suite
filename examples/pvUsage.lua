local function testFunction1() 
    KSR.pv.sets("$avp(test)","test string")
end

local function testFunction2() 
    return KSR.pv.getvs("$avp(test)","default string")
end

return {
    testFunction1 = testFunction1,
    testFunction2 = testFunction2,
}

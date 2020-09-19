return {
    dp_replace = function( tag,dataToReplace,varToPutNewData )
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),3,tag,dataToReplace,varToPutNewData)
        variables["$avp"]["s:dest"]  = testData.callDirection or "INBOUND"
        variables["$ru"] = testData.callDestination or "999999999@3.3.3.3:5070"
        variables["$avp"]["newDest"] = testData.callDestination  or "999999999@3.3.3.3:5070"
    end
}
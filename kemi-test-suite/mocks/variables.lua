return function(testData) 
    return {
        ["$TV"] = {
            un = testData["$TV"] or "1234567890.12345",
            sn = testData["$TV"] or "1234567890.12345",
            s = testData["TV"] or 1234567890
        },
        ["$hdr"] = testData.headers or testData["$hdr"] or {},
        ["$var"] = testData["$var"] or {},
        ["$avp"] = testData["$avp"] or {},
        ["$xavp"] = testData["$xavp"] or {},
        ["$jsonrpl"] = {},
        ["$conid"] = testData["$conid"],
        ["$sht"] = testData["$sht"] or testData.htable or {},
        ["htable"] = testData.htable or testData["$sht"] or {},
        ["$shtex"] = testData["$shtex"] or {},
        ["$expires"] = testData["$expires"] or {},
    }
end
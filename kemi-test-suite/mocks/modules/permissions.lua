return {
    allow_source_address = function( group )
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,group)
        local map = testData.allowedAddressMap or {
            ["1"] = { "1.1.1.1" }
        }
        for k,v in pairs(map) do
            if map[tostring(group)] and map[tostring(group)][i] == variables.si then
                variables["$avp"]["i:707"] = testData.permissionsTag or "1"
                return 1
            end
        end
        return -1
    end
}
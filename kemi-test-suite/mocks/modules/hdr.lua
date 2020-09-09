return {
    is_present = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        for k,v in pairs(variables["$hdr"]) do
            if k == name then
                return 1
            end
        end
        return -1
    end,
    append = function(headerString)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,headerString)
        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end,
    append_after = function(headerString,afterHeaderName)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,headerString,afterHeaderName)
        -- ignoring here afterHeaderName because of table will mix fields as it wants for now
        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end,
    append_to_reply = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end,
    remove = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        if variables["$hdr"][name] then
            variables["$hdr"][name] = nil
        end
    end,
    insert = function(headerString)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,headerString)
        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end
}
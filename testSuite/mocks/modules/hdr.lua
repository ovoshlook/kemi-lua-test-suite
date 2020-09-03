return {
    is_present = function(name)
        for k,v in pairs(variables["$hdr"]) do
            if k == name then
                return 1
            end
        end
        return -1
    end,
    append = function(headerString)
        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end,
    append_after = function(headerString,afterHeaderName)
        -- ignoring here afterHeaderName because of table will mix fields as it wants for now
        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end,
    remove = function(neaderName)
        if variables["$hdr"][headerName] then
            variables["$hdr"][headerName] = nil
        end
    end,
    insert = function(headerString)

        for headerName,headerValue in string.gmatch(headerString,"([%w%-]+): ([%w%-:%+%s]+)\r\n") do
            variables["$hdr"][headerName] = headerValue
        end
    end
}
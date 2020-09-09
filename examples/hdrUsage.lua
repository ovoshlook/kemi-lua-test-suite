local  function addHeader() 
    KSR.hdr.append("TEST: data\r\n")
end

local  function removeHeader() 
    KSR.hdr.remove("TEST2")
end

local mymodule = {
    addHeader = addHeader,
    removeHeader = removeHeader
}

return mymodule
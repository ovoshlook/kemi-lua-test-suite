local function query(query,callbackName) 
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,query,callbackName)
    return 1
end

return {
    query = query
}
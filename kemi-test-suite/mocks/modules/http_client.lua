local function query(url,res)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,url,res)
    return 1
end

return {
    query = query
}
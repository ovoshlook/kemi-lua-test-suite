local function query(url,res)
    if not (url or res) then
        return -1
    end
    return 1
end

return {
    query = query
}
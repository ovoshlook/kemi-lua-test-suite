local function get_srcip()
    return variables["$si"]
end

local function get_srcport()
    return variables["$sp"]
end

return {
    get_srcip = get_srcip,
    get_srcport = get_srcport
}
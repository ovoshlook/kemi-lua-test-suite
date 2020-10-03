local function get_srcip()
    return variables["$si"]
end

local function get_srcport()
    return variables["$sp"]
end

local function get_fuser() 
    return variables["$fU"]
end

local function get_fhost()
    return variables["$fd"]
end

local function get_furi()
    return variables["$fu"]
end

local function get_tuser() 
    return variables["$tU"]
end

local function get_thost()
    return variables["$td"]
end

local function get_turi()
    return variables["$tu"]
end

local function get_ruser() 
    return variables["$rU"]
end

local function get_rhost()
    return variables["$rd"]
end

local function get_ruri()
    return variables["$ru"]
end

local function get_callid()
    return variables["$ci"]
end

return {
    get_srcip = get_srcip,
    get_srcport = get_srcport,
    get_fuser = get_fuser,
    get_fhost = get_fhost,
    get_furi = get_furi,
    get_tuser = get_tuser,
    get_thost = get_thost,
    get_turi = get_turi,
    get_ruser = get_ruser,
    get_rhost = get_rhost,
    get_ruri = get_ruri,
    get_callid = get_callid
}
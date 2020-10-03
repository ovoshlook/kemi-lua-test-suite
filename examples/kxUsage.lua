local function getCallid()
    return KSR.kx.get_callid()
end

local function getSourceIP()
    return KSR.lx.get_srcip()
end

local function getSourcePort()
    return KSR.lx.get_srcport()
end

local function getFromUser()
    return KSR.lx.get_fuser()
end

local function getFromHost()
    return KSR.lx.get_fhost()
end

local function getFromUri()
    return KSR.lx.get_furi()
end

local function getToUser()
    return KSR.lx.get_tuser()
end

local function getToHost()
    return KSR.lx.get_thost()
end

local function getToUri()
    return KSR.lx.get_turi()
end

local function getRURIUser()
    return KSR.lx.get_ruser()
end

local function getRURIHost()
    return KSR.lx.get_rhost()
end

local function getRUri()
    return KSR.lx.get_ruri()
end

return {
    getCallid = getCallid,
    getSourceIP = getSourceIP,
    getSourcePort = getSourcePort,
    getFromHost = getFromHost,
    getFromUser = getFromUser,
    getFromUri = getFromUri,
    getToHost = getToHost,
    getToUser = getToUser,
    getToUri = getToUri,
    getRURIHost = getRURIHost,
    getRURIUser = getRURIUser,
    getRUri = getToRUri,
}
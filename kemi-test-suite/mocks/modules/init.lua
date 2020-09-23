local myPath = "kemi-test-suite.mocks.modules."

local modules = {
    "corex",
    "tm",
    "dialplan",
    "hdr",
    "http_async_client",
    "http_client",
    "jsonrpcs",
    "kx",
    "maxfwd",
    "nathelper",
    "permissions",
    "pv",
    "registrar",
    "rtpengine",
    "sanity",
    "sdpops",
    "siputils",
    "sl",
    "sqlops",
    "statsd",
    "tcpops",
    "textops",
    "textopsx",
    "xhttp",
}

local function generate(modules) 
    local init = {}
    for i in ipairs(modules) do
        init[modules[i]] = require(myPath..modules[i])
    end
    return init
end 

return generate(modules)
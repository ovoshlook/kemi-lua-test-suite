local testMockModules = {
    sanity              = require "mocks.modules.sanity",
    tcpops              = require "mocks.modules.tcpops",
    registrar           = require "mocks.modules.registrar",
    rtpengine           = require "mocks.modules.rtpengine",
    jsonrpcs            = require "mocks.modules.jsonrpcs",
    nathelper           = require "mocks.modules.nathelper",
    pv                  = require "mocks.modules.pv",
    siputils            = require "mocks.modules.siputils",
    permissions         = require "mocks.modules.permissions",
    hdr                 = require "mocks.modules.hdr",
    http_client         = require "mocks.modules.http_client",
    http_async_client   = require "mocks.modules.http_async_client"
}

return testMockModules
--// Just an example how to make functions from config tesTable

local testSuite = require "kemi-test-suite.init"
local mymodule = require "mymodule"

function ksr_request_route () 
    local si = KSR.pv.get("$si")
    KSR.info("test running: "..si)
    KSR.http_client.query("http://localhost","$avp(body)")
    local replyCode = KSR.pv.get("$rc")
    local body = KSR.pv.get("$avp(body)")
    KSR.info(tostring(replyCode)..": "..tostring(body))
end

testSuite.run(
    { 
        mymodule=mymodule
    }
)
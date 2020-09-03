--// Just an example how to make functions from config tesTable

local testSuite = require "testSuite.init"
local mymodule = require "mymodule"

function ksr_request_route () 
    KSR.info("test running")
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
--// Just an example how to make functions from config tesTable

local testSuite = require "kemi-test-suite.init"
local mymodule = require "mymodule"
local nestedTest = require "nested.subnested.test"

function ksr_request_route () 
    if KSR.maxfwd.process_maxfwd(10) < 0 then
        KSR.err("maxfwd")
    end
    local si = KSR.pv.get("$si")
    KSR.info("test running: "..si)
    KSR.http_client.query("http://localhost","$avp(body)")
    local replyCode = KSR.pv.get("$rc")
    local body = KSR.pv.get("$avp(body)")
    KSR.info(tostring(replyCode)..": "..tostring(body))
end

function global_test_route ()
    nestedTest.testFunc()
end

testSuite.run()
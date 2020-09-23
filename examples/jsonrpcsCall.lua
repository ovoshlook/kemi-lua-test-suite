local json = require "cjson"

local function call() 
    KSR.jsonrpcs.exec(json.encode({jsonrpc = "2.0", method = "dispatcher.add", params={1,"sip:127.0.0.1:5060"}}))
end

return {
    call = call
}
local JSON = require "cjson.safe"

local jsonrpcs = {
    exec = function(jsonedRequest)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,jsonedRequest)
        local api = {
            ["dispatcher.add"] = function(params) 
                if not params or not (params[1] and params[2]) then
                    variables["$jsonrpl"]["body"]=JSON.encode({"jsonrpc"="2.0","error" = {"code" = 500,"message" = "Invalid Parameters"}})
                    return
                end
                variables["$jsonrpl"]["body"]=JSON.encode({"jsonrpc"="2.0","result" = {}})
            end,

            ["dispatcher.list"] = function(params)
                if testData.dispatcherList then

                    local dListTemplate = {
                        jsonrpc = "2.0",
                        result = {
                            NRSETS = 2,
                            RECORDS = {}
                        }
                    }
                    for i=1,#testData.dispatcherList do
                        dListTemplate.result.RECORDS[i] = {
                            SET = {
                                ID = i,
                                TARGETS = {
                                    {
                                        DEST = {
                                            URI = testData.dispatcherList[i].uri,
                                            FLAGS = testData.dispatcherList[i].flag,
                                            PRIORITY = 0
                                        }
                                    }
                                }
                            }
                        }
                    end
                    variables["$jsonrpl"]["body"] = JSON.encode(dListTemplate)
                else
                    variables["$jsonrpl"]["body"] = JSON.encode(testData.dispatcherList) or '{"jsonrpc":"2.0","result":{"RECORDS":[{"SET":{"ID":2,"TARGETS":[{"DEST":{"URI":"sip:10.10.120.149:5160","FLAGS":"AP","PRIORITY":0}}]}},{"SET":{"ID":1,"TARGETS":[{"DEST":{"URI":"sip:10.10.120.148:5160","FLAGS":"AX","PRIORITY":0}}]}}],"NRSETS":2}}'
                end
            end,

            ["rtpengine.reload"] = function(params) return true end,
            ["rtpengine.show"] = function(params)
                local response = {
                    ["all"] = (function ()
                        if testData.rtpengineList then
                            local rListTemplate = {
                                jsonrpc = "2.0",
                                result = {}
                            }
                            for i=1,#testData.rtpengineList do
                                rListTemplate.result[i] = {
                                    recheck_ticks = 0,
                                    index = 0,
                                    set = 1,
                                    url = testData.rtpengineList[i].uri,
                                    disabled = testData.rtpengineList[i].disabled,
                                    weight = 1
                                }
                            end
                            variables["$jsonrpl"]["body"] = JSON.encode(rListTemplate)
                        else
                            variables["$jsonrpl"]["body"] = JSON.encode(testData.rtpengineList) or '{"jsonrpc":"2.0","result":[{"recheck_ticks":0,"index":0,"set":1,"url":"udp:192.168.11.102:7724","disabled":0,"weight":1}]}'
                        end
                    end)()
                }
                return response[params]
            end ,

            ["htable.get"] = function(params)
                --or '{"jsonrpc":"2.0","result":{"item":{"name":"name","value":"value"}}}'
                local htableName = params[1]
                if variables.htable[htableName] then
                    local htable = variables.htable[htableName]
                    if next(htable) then
                        for i = 1,#htable do
                            if htable[i].name == params[2] then
                                variables["$jsonrpl"]["body"] = JSON.encode({result = { item = { name = params[2], value = htable[i].value}}})
                                return
                            end
                        end
                    end
                    variables["$jsonrpl"]["body"] = JSON.encode({error = "Not found"})
                else
                    variables["$jsonrpl"]["body"] = JSON.encode({error = "table not exists"})
                end
            end,

            ["htable.sets"] = function(params)
                variables["$jsonrpl"]["body"] = JSON.encode({jsonrpc = "2.0",result = { item = { name = params[2], value = params[3]}}})
            end
        }
        local request = JSON.decode(jsonedRequest)
        api[request.method](request.params)
    end
}

return jsonrpcs
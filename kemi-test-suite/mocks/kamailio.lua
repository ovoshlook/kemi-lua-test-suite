local json = require "cjson.safe"
local colors = require "kemi-test-suite.colors"

-- Activation function to emulate KSR engine of kamailio
-- returns predefined default values of the KSR functions and modules for tests
-- "testData" param used to get test predefined vaules, if no predefined - default vaules will be used

local internalLogging = false
local pathToModules = "kemi-test-suite.mocks.modules."

function KAMAILIO_CRASH_CHECK(...) 
    if not arg[1] and not arg[2] then
        print(colors("\n%{bright yellow}KAMAILIO_CRASH_CHECK(...) %{white}has to receive at least 2 params:\n - arg[1]:   debug.getinfo(1)\n - arg[2]:   number of KSR.module.function params\n - arg[2+x]: params passed into function\n"))
        os.exit()
    end
    local funcDetails=arg[1]
    local numOfParams=arg[2]
    if numOfParams > 0 then
        for i=3,(2+numOfParams) do
            if not arg[i] then
                local moduleName = string.match(funcDetails.short_src,"/([%w_]+).lua")
                print(colors("\n%{bright red}Call of the %{reset}%{blue}KSR.%{magenta}"..moduleName..".%{yellow}"..funcDetails.name.."(%{red}<here_is_your_params>%{white}) %{bright red} will cause crash of the kamailio during runTime.\n It wil happend because some of the params wasn't passed.\n Fix the script, read the docks and come back again\n"))
                os.exit()
            end
        end
    end
end

local defaults = require("kemi-test-suite.mocks.variables")

local function init(testData,mocks)
    
    variables = defaults(testData)
    
    -- changed variables that should be affected AFTER all packet handing script done
    local changed = {}

    internalLogging = testData.internalLogging or false
  
    local force_rport = function ()
        return
    end

    local isdsturiset = function ()
        if not variables["$du"] then
            return false
        end
        return true
    end

    local forward = function ()
        return
    end

    local x = {
        exit = function()
            os.exit()
        end
    }

    local maxfwd = {
        process_maxfwd = function(limit)
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,limit)
            local f = testData.forwards or 4
            if f > limit then
                return -1
            end
            return 1
        end
    }

    local sanity = {
        sanity_check = function(flag1, flag2)
            -- implement logic for flags if need to test
            return 1
        end
    }

    local textops = {
        remove_hf_re = function(regex)
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,regex)
            -- implement logic to remove header in headers array
            return
        end
    }

    local textopsx = {
        msg_apply_changes = function()
            return
        end
    }

    local dialplan = {
        dp_replace = function( tag,dataToReplace,varToPutNewData )
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),3,tag,dataToReplace,varToPutNewData)
            variables["$avp"]["s:dest"]  = testData.callDirection or "INBOUND"
            variables["$ru"] = testData.callDestination or "999999999@3.3.3.3:5070"
            variables["$avp"]["newDest"] = testData.callDestination  or "999999999@3.3.3.3:5070"
            --print(JSON.encode(variables["$avp"]))
        end
    }

    local statsd = {
        statsd_incr = function()
            return
        end,
        statsd_decr = function()
            return
        end
    }

    local sl = {
        send_reply = function(code,reason)
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,code,reason)
            return
        end
    }

    local sdpops = {
        sdp_content = function()
            if not variables["$rb"] then
                return -1
            end
            return 1
        end
    }

    local sqlops = {
        sql_xquery = function(conn,query,res)
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),3,conn,query,res)
            return
        end
    }

    local xhttp = {
        xhttp_reply = function (code, reason, type, data) 
            KAMAILIO_CRASH_CHECK(debug.getinfo(1),4,code, reason, type, data)
            return
        end
    }

    local printLog = function (...)
        if internalLogging then
            print(...)
        end
    end

    --  >= 5.0
    _G["KSR"] = {
        log         = printLog,
        info        = printLog,
        dbg         = printLog,
        warn        = printLog,
        err         = printLog,
        changed     = changed,
        force_rport = force_rport,
        isdsturiset = isdsturiset,
        forward     = forward,
        x           = x,
        pv          = require (pathToModules.."pv"),
        maxfwd      = maxfwd,
        sanity      = sanity,
        siputils    = siputils,
        isdsturiset = isdsturiset,
        dialplan    = dialplan,
        permissions = require (pathToModules.."permissions"),
        jsonrpcs    = require (pathToModules.."jsonrpcs"),
        nathelper   = require (pathToModules.."nathelper"),
        statsd      = statsd,
        hdr         = require (pathToModules.."hdr"),
        sl          = sl,
        sdpops      = sdpops,
        rtpengine   = require (pathToModules.."rtpengine"),
        textops     = textops,
        textopsx    = textopsx,
        sqlops      = sqlops,
        xhttp       = xhttp,
        registrar   = require (pathToModules.."registrar"),
        tcpops      = require (pathToModules.."tcpops"),
        http_client = require (pathToModules.."http_client")
    }

    --  <= 4.4
    _G["sr"] = {
        log         = printLog,
        info        = printLog,
        warn        = printLog,
        dbg         = printLog,
        err         = printLog,
        changed     = changed,
        force_rport = force_rport,
        isdsturiset = isdsturiset,
        forward     = forward,
        x           = x,
        pv          = require (pathToModules.."pv"),
        maxfwd      = maxfwd,
        sanity      = sanity,
        siputils    = siputils,
        isdsturiset = isdsturiset,
        registrar    = require (pathToModules.."registrar")
    }
    
    return internalLogging
end

return {
    init = init
}
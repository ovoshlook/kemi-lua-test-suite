local json = require "cjson.safe"

-- Activation function to emulate KSR engine of kamailio
-- returns predefined default values of the KSR functions and modules for tests
-- "testData" param used to get test predefined vaules, if no predefined - default vaules will be used

local internalLogging = false

local function init(testData,mocks)
    
    variables = {
        ["$si"] = testData.si or "1.1.1.1" ,
        ["$sp"] = testData.sp or "5060",
        ["$pr"] = testData.pr or "udp",
        ["$rd"] = testData.td or "2.2.2.2",
        ["$rp"] = testData.rp or "6050",
        ["$rP"] = testData.rP or "udp",
        ["$ds"] = testData.ds or "3.3.3.3",
        ["$dp"] = testData.dp or "5090",
        ["$dP"] = testData.dP or "udp",
        ["$ru"] = testData.ru or "999999999@2.2.2.2:6050",
        ["$rU"] = testData.rU or "999999999",
        ["$ci"] = testData.ci or "asdf-1234-asdf",
        ["$rm"] = testData.rm or "INVITE",
        ["$ct"] = testData.ct or "sip:1.1.1.1:5060",
        ["$fU"] = testData.fU or "111111111",
        ["$fd"] = testData.fd or "1.1.1.1:5060",
        ["$fu"] = testData.fu or "111111111@1.1.1.1:5060",
        ["$tU"] = testData.tU or "999999999",
        ["$td"] = testData.td or "2.2.2.2:6050",
        ["$tu"] = testData.tu or "999999999@2.2.2.2:6050",
        ["$du"] = testData.du,
        ["$rb"] = testData.rb,
        ["$rs"] = testData.rs,
        ["$ft"] = testData.ft,
        ["$tt"] = testData.tt,
        ["$hu"] = testData.hu,
        ["$http_rb"] = testData.http_rb,
        ["$TV"] = {
            un = testData.TV or "1234567890.12345",
            sn = testData.TV or "1234567890.12345",
            s = testData.TV or 1234567890
        },
        ["$hdr"] = testData.headers or testData.hdr or {},
        ["$var"] = testData.var or {},
        ["$avp"] = testData.avp or {},
        ["$xavp"] = testData.xavp or {},
        ["$jsonrpl"] = {},
        ["$conid"] = testData.conid,
        ["$sht"] = testData.sht or testData.htable or {},
        ["htable"] = testData.htable or testData.sht or {},
        ["$shtex"] = testData.shtex or {},
        ["$expires"] = testData.expires or {},
    }
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
        remove_hf_re = function(regularExpression)
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
            return
        end
    }

    local xhttp = {
        xhttp_reply = function (code, reason, type, data) 
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
        pv          = require "testSuite.mocks.modules.pv",
        maxfwd      = maxfwd,
        sanity      = sanity,
        siputils    = siputils,
        isdsturiset = isdsturiset,
        dialplan    = dialplan,
        permissions = require "testSuite.mocks.modules.permissions",
        jsonrpcs    = require "testSuite.mocks.modules.jsonrpcs",
        nathelper   = require "testSuite.mocks.modules.nathelper",
        statsd      = statsd,
        hdr         = require "testSuite.mocks.modules.hdr",
        sl          = sl,
        sdpops      = sdpops,
        rtpengine   = require "testSuite.mocks.modules.rtpengine",
        textops     = textops,
        textopsx    = textopsx,
        sqlops      = sqlops,
        xhttp       = xhttp,
        registrar   = require "testSuite.mocks.modules.registrar",
        tcpops      = require "testSuite.mocks.modules.tcpops"
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
        pv          = require "testSuite.mocks.modules.pv",
        maxfwd      = maxfwd,
        sanity      = sanity,
        siputils    = siputils,
        isdsturiset = isdsturiset,
        registrar    = require "testSuite.mocks.modules.registrar"
    }
    
    return internalLogging
end

return {
    init = init
}
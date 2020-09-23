return {
    send_reply = function(code,reason)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,code,reason)
        return 1
    end,
    sl_send_reply = function(code,reason)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,code,reason)
        return 1
    end,
    sl_forward_reply = function(code,reason)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,code,reason)
        return 1
    end,
    sl_send_error = function()
        return 1
    end
}
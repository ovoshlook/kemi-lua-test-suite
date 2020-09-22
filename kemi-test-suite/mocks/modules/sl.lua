return {
    send_reply = function(code,reason)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,code,reason)
        return
    end
}
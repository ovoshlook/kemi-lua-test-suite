local xhttp = {

    xhttp_reply = function (code, reason, type, data) 
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),4,code, reason, type, data)
        return
    end

}

return xhttp
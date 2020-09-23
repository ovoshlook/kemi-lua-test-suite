return {
    t_is_set = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end,
    t_on_branch = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end,
    t_on_reply = function(name)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end,
    t_on_failure = function(name) 
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end,
    t_relay = function(name) 
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,name)
        return 1
    end

}
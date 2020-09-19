return {
    process_maxfwd = function(limit)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,limit)
        local f = variables.forwards or 4
        if f > limit then
            return -1
        end
        return 1
    end
}
return {

    sanity_check = function(flag1, flag2)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,flag1,flag2)
        -- implement logic for flags if need to test
        return 1
    end

}

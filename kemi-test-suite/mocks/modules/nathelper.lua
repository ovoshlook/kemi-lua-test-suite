return {
    nat_uac_test = function(num)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,num)
        count = 0
         --  only rfc1918. TODO: add rfc6598
        local networks = {
            ":10.",
            ":172.16.",
            ":192.168."
        }
        i = 1
        -- check for flag 1 of nathelper
        while count == 0 do
            if string.gmatch(variables["$ct"],networks[i]) then
                count = 1
            end
            i = i+1
        end
        -- check for flag 2 of nathelper
        count = count + 2

        -- check for flag 16 of nathelper
        count = count + 16

        if count == 19  then
            return 1
        end
        return -1
    end,
    set_contact_alias = function()
        variables["$ct"] = variables["$ct"]..";alias="..variables["$si"].."~"..variables["$sp"].."~udp"
    end,
    handle_ruri_alias = function()
        if string.match(variables["$ru"],"alias") then
            -- remove and put alias to $du actually but for now just returns. Enoguth for testing
            return
        end
    end
}
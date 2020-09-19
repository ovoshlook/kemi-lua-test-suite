return {
    sdp_content = function()
        if not variables["$rb"] then
            return -1
        end
        return 1
    end
}
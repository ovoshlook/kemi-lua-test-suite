return {
    is_request = function()
        if variables["$rs"] then
            return -1
        end
        return 1
    end,
    is_reply = function()
        if variables["$rs"] then
            return 1
        end
        return -1
    end,
    has_totag = function()
        if variables["$tt"] then
            return 1
        end
        return -1
    end
}
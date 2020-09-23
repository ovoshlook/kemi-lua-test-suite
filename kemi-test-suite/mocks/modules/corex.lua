local function has_ruri_user()
    if variables["$rU"] then
        return 1
    end
    return -1
end

return {
    has_ruri_user = has_ruri_user
}
local function checkOptions()
    return KSR.is_OPTIONS()
end

local function checkInvite()
    return KSR.is_INVITE()
end

return {
    checkOptions = checkOptions,
    checkInvite = checkInvite
}
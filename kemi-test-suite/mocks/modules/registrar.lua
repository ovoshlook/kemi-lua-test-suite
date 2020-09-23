
local function save(where,how)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,where,how)
    return 1
end

local function save_uri(where,how,what)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),3,where,how,what)
    return 1
end

local function registered_action(where,what,how) 
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),3,where,how,what)
    return 1
end 

local function unregister(where,what) 
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,where,what)
    return t1
end 

local registrar = {
    save = save,
    save_uri = save_uri,
    registered_action = registered_action
}

return registrar
    
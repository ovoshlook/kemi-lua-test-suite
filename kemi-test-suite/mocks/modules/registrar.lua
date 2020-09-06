
local function save(where,how)
    if not (where or how) then
        return -1
    end
    return 1
end

local function save_uri(where,how,what)
    if not (where or how or what) then
        return -1
    end
    return 1
end

local function registered_action(where,what,how) 
    if not (where or how or what) then
        return false
    end
    return true
end 

local function unregister(where,what) 
    return true
end 

local registrar = {
    save = save,
    save_uri = save_uri,
    registered_action = registered_action
}

return registrar
    
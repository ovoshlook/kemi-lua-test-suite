local function get (var)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,var) 
    -- $rU, $ct
    local res = variables[var]
    --$hdr(Header-Name) , --$avp(Name)
    if not res then
        local prefix,name = string.match(var,"(%$%a+)%(([%w%-_%s:=>%.%{%}%[%]]+)%)") 
        if variables[prefix] and variables[prefix][name] then
            res = variables[prefix][name]
        end
    end
    --$(hdr(Header-Name)[id]) , --$(avp(Name)[id])
    if not res then
        local prefix,name,id = string.match(var,"%$%((%a+)%(([%w%-_%s:=>%.%{%}]+)%)%[(%d+)%]%)")
        if prefix and name and id then
            prefix = "$"..prefix
            id = id + 1 -- because of kamailio stores array from 0 and lua from 1
            if variables[prefix] and variables[prefix][name] and variables[prefix][name][id] then
                res = variables[prefix][name][id]
            end
        end
    end
    --$(prefix(name)option)
    if not res then
        local name = string.match(var,"%$(%([%w%-_%s:=>%.%{%}%(%)]+%))")
        res = variables[name]
    end
    return res
end

 local function seti (var,val)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,var,val)
    local prefix,name,id = string.match(var,"%$%((%a+)%(([%w%-%s:=>%.%{%}]+)%)%[(%d+)%]%)")
    if prefix and name and id then -- save it as variables[prefix][name][id]
        -- print("setting to var '"..prefix.."->"..name.."["..id.."]' value "..val)
        prefix = "$"..prefix
        if  variables[prefix][name] then
            variables[prefix][name][id] = tonumber(val)
            return
        else
            variables[prefix][name] = {}
            variables[prefix][name][id] = tonumber(val)
            return
        end
    end

    local prefix,name = string.match(var,"($%a+)%(([%w%-%s:=>%.%{%}]+)%)")
    if prefix and name then -- save it as variables[prefix][name]
        variables[prefix][name] = tonumber(val)
        --print("setting to '"..prefix.."->"..name.." value "..val)
        return
    end


    variables[var] = tonumber(val)  -- save it as variables[var]
    return
end

local function sets (var,val)
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,var,val)
    local prefix,name,id = string.match(var,"%$%((%a+)%(([%w%-%s:=>%.%{%}]+)%)%[(%d+)%]%)") 
    -- save it as variables[prefix][name][id]
    if prefix and name and id then 
        prefix = "$"..prefix
        -- print("setting to var '"..prefix.."->"..name.."["..id.."]' value "..val)
        if  variables[prefix][name] then
            variables[prefix][name][id] = val 
            return
        else
            variables[prefix][name] = {}
            variables[prefix][name][id] = val
            return
        end
    end
        
    local prefix,name = string.match(var,"($%a+)%(([%w%-%s:=>%.%{%}]+)%)")

    if prefix and name then -- save it as variables[prefix][name]
        --print("setting to '"..prefix.."->"..name.."' value "..val)
        variables[prefix][name] = val
        return
    end

    variables[var] = tostring(val)
    return
end

local function getvs(var,default) 
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,var,default)
    local val = get(var)
    if not val then
        return default
    end
    return val
end

return {
    get=get,
    getvs=getvs,
    sets=sets,
    seti=seti
}
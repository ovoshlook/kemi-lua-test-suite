local json = require "cjson.safe"
local colors = require "kemi-test-suite.colors"

-- Activation function to emulate KSR engine of kamailio
-- returns predefined default values of the KSR functions and modules for tests
-- "testData" param used to get test predefined vaules, if no predefined - default vaules will be used

local internalLogging = false
local pathToModules = "kemi-test-suite.mocks.modules."

function KAMAILIO_CRASH_CHECK(...) 
    if not arg[1] and not arg[2] then
        print(colors("\n%{bright yellow}KAMAILIO_CRASH_CHECK(...) %{white}has to receive at least 2 params:\n - arg[1]:   debug.getinfo(1)\n - arg[2]:   number of KSR.module.function params\n - arg[2+x]: params passed into function\n"))
        os.exit()
    end
    local funcDetails=arg[1]
    local numOfParams=arg[2]
    if numOfParams > 0 then
        for i=3,(2+numOfParams) do
            if not arg[i] then
                local moduleName = string.match(funcDetails.short_src,"/([%w_]+).lua")
                print(colors("\n%{bright red}Call of the %{reset}%{blue}KSR.%{magenta}"..moduleName..".%{yellow}"..funcDetails.name.."(%{red}<here_is_your_params>%{white}) %{bright red} will cause crash of the kamailio during runTime.\n It wil happend because some of the params wasn't passed.\n Fix the script, read the docks and come back again\n"))
                os.exit()
            end
        end
    end
end

local defaults = require("kemi-test-suite.mocks.variables")

local mockModules = {}
local moduleFiles = io.popen('ls -a "'..string.gsub(pathToModules,"%.","/")..'"*.lua')

for module in moduleFiles:lines() do
    local moduleName = string.match(module,"/([%w_-]+)%.lua")
    print(colors("Module found: %{blue}"..module.."%{reset} as %{bright magenta}"..moduleName))
    mockModules[moduleName] = require (pathToModules.."."..moduleName)
end

moduleFiles:close()

local function init(testData,mocks)
    
    variables = defaults(testData)
    
    -- changed variables that should be affected AFTER all packet handing script done
    local changed = {}

    internalLogging = testData.internalLogging or false
  
    local force_rport = function ()
        return
    end

    local isdsturiset = function ()
        if not variables["$du"] then
            return false
        end
        return true
    end

    local is_method_in = function(str)
        KAMAILIO_CRASH_CHECK(debug.getinfo(1),1,str)
        local method = variables["$rm"]
        for i = 1, #str do
            local c = str:sub(i,i)
            if str[i] == method[1] then
                return true
            end
        end
        return false
    end

    local forward = function ()
        return
    end

    local x = {
        exit = function()
            --@TODO: os.exit is bad solution, replace with something that not destroys script
            os.exit()
        end
    }

    local printLog = function (...)
        if internalLogging then
            print(...)
        end
    end

    --  >= 5.0
    local modules = {
        log         = printLog,
        info        = printLog,
        dbg         = printLog,
        warn        = printLog,
        err         = printLog,
        changed     = changed,
        force_rport = force_rport,
        isdsturiset = isdsturiset,
        forward     = forward,
        x           = x
    }

    for k,v in pairs(mockModules) do
        modules[k] = v
    end

    package.loaded["KSR"] = modules

    _G["KSR"] = package.loaded["KSR"]
    
    return internalLogging
end

return {
    init = init
}
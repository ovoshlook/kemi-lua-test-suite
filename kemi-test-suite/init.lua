TEST = true

for i=1,#arg do
    if arg[i] == "--stop-on-fail" then
        STOP_ON_FAIL = true
    end
end

local colors = require "kemi-test-suite.colors"
local json = require "cjson.safe"
-- local s = require("say")
local testMock = require('kemi-test-suite.mocks.kamailio')

local testAlgorithms = {
    same        = "same",
    notSame     = "notSame",
} 

local Logging = false

local testDefaults = {
    algo = testAlgorithms.same
}

--[[ 
initial Mock start to initialize environment

param tests - path to tests relatively depended of root kamailio.lua file lays
param modules is a table contains modules if they are  included as local
example:

local mymodule1 = require("mymodule")
...
testSuite.init("tests.init",
    {
        mymodule1 = mymodule1
        mymodule2 = mymodule2
    }
)
]]

function splitStr (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function printTable(t) 
    for k,v in pairs(t) do
        print("key: "..k.." value: "..tostring(v))
        if type(v)=="table" then printTable(v) end
    end
end

local function defineMocs(mocks)
  
    if not mocks then return nil end
    local mocked = {}
    for i=1,#mocks do
       
        local key = mocks[i].what[1] 
        local module = mocks[i].what[2]
        local target = mocks[i].what[3]

        if key == "_G" then
            if not _G[module] then
                print(colors("%{bright yellow}No \""..key.."."..module.."."..target.."\" found. Creating it insead of mocking.."))
                package.loaded[module] = {
                    [target] = mocks[i].to
                }
                table.insert(mocked,{key = key, module = module, target = target })
            else  
                if _G[module] then
                    package.loaded[module][target] = mocks[i].to
                end
                table.insert(mocked,{key = key, module = module, target = target, func = _G[module][target] })
            end

        else
            if not _G[key] or not _G[key][module] then

                print(colors("%{bright yellow}No \""..key.."."..module.."."..target.."\" found. Creating it insead of mocking.."))
                if _G[key] then
                    _G[key][module]={}
                else 
                    _G[key] = {
                        [module]={}
                    }
                end
                table.insert(mocked,{key = key, module = module, target = target })
            else  
                table.insert(mocked,{key = key, module = module, target = target, func = _G[key][module][target] })
            end
            _G[key][module][target] = mocks[i].to
        end
    end

    return mocked

end

local function undefineMocs(mocked)
    if not mocked then return end
    for i=1,#mocked do
        local key = mocked[i].key 
        local module = mocked[i].module
        local target = mocked[i].target
        if key == "_G" then
            package.loaded[module] = nil
        else
            _G[key][module][target] = mocked[i].func
        end
    end
end

local function testedFunctionInit(testedModule,testedFunction)
    if not testedModule then
        return _G[testedFunction]
    elseif not package.loaded[testedModule] then
        local m = loadfile(testedModule)
        return m()[testedFunction]
    end
    return package.loaded[testedModule][testedFunction]
end

local scenarios = {

    same = function(testScenario)
        if testScenario.resultContainer then
            testScenario.testedFunction( unpack(testScenario.testedFunctionArgs) )
            local res = variables
            local c = testScenario.resultContainer
            for i=1,#c do
                res = res[c[i]]
            end
            if (json.encode(testScenario.expectedResult) == json.encode(res)) then
                return true,res
            end
            return false,res
        else
            local res = testScenario.testedFunction( unpack(testScenario.testedFunctionArgs) )
            if not res and type(testScenario.expectedResult) == "table" then
                res = {}
            end
            if (json.encode(testScenario.expectedResult) == json.encode(res)) then
                return true,res
            end
            return false,res
        end
    end,

    notSame = function(testScenario)
        if testScenario.resultContainer then

            testScenario.testedFunction( unpack(testScenario.testedFunctionParams) )
            local res = variables
            local c = testScenario.resultContainer
            for i=1,#c do
                res = res[c[i]]
            end
            if (json.encode(testScenario.expectedResult) == json.encode(res)) then
                return false,res
            end
            return true,res

        else

            local res = testScenario.testedFunction( unpack(testScenario.testedFunctionParams))

            if not res then
                res = {}
            end
            
            if (json.encode(testScenario.expectedResult) == json.encode(res)) then
                return false,res
            end

            return true,res

        end
    end,
}

function beautify(this)
    if this == nil then
        return "nil"
    elseif this == false then
        return "false"
    elseif type(this) == "function" then
        return "function" 
    elseif type(this) == "table" then
        return '"table: '..json.encode(this)..'"'
    end
    return '"'..tostring(this)..'"'
end

function callTest(testContainer,results)
    for k in pairs(testContainer) do
        if not testContainer[k] then
            print(colors("%{bright red}\nCan't find test configured in tests%{reset} for \""..k.."\"]\n"))
        elseif type(testContainer[k]) ~= "table"   then 
            print(colors("%{bright red}\nCan't run test: %{reset} \""..k.."\" has to be a table with configured parameters, but now it is type of \""..type(testContainer[k]).."\"\n"))    
        elseif type(testContainer[k]) == "table" then
            local failed
            if not (testContainer[k].testedFunction) and not (testContainer[k].description) then
                callTest(testContainer[k],results)
            else
                local checkRes,testRes = test(k,testContainer[k],results)
                if checkRes then
                    results.passed = results.passed + 1
                else
                    results.failed = results.failed + 1
                    print(colors("%{red}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"))
                    print(colors("%{bright blue}"..k.." %{bright red} FAILED! %{bright white} \nExpected: %{bright yellow}"..beautify(testContainer[k].expectedResult).."%{bright white}\ngot:      %{bright red}"..beautify(testRes).."\n"))
                    if STOP_ON_FAIL then failed = true end
                end
                results.total = results.total + 1
                if failed then return end
            end
        end
    end

    return results

end

function test(testName,testScenario)
        
    if not testScenario.algorithm then
        testScenario.algorithm = testDefaults.algo
    end

    if not testScenario.testedFunctionArgs then
        testScenario.testedFunctionArgs = {}
    end

    print(colors("%{bright white}Running test: %{bright blue}\""..testName.."\": %{bright white}it "..testScenario.description..". %{bright green}Algo: %{bright yellow}"..testScenario.algorithm))
            
    local params    = testScenario.withParams or {}
    local mocks     = testScenario.mocks

    Logging = testMock.init(params)

    local mocked = defineMocs(mocks)

    if Logging then
        print(colors("%{bright white}Test %{bright blue}\""..testName.."\" %{bright white}output:"))
        print(colors("%{bright blue}-------------------------------------------------------- "))
    end

    testScenario.testedFunction = testedFunctionInit(testScenario.testedModule,testScenario.testedFunction)
    local checkRes,testRes = scenarios[testScenario.algorithm](testScenario)
    if Logging then
        print(colors("%{bright blue}--------------------------------------------------------"))
    end
    print()

    undefineMocs(mocked)

    return checkRes,testRes

end

local function run()
    
    if not os.getenv("KAMAILIO_TESTSUITE_LUA") then 
        return
    end
    
    testMock.init({})

    local tests = require("tests.init")
    local results = callTest(tests,{
        total = 0,
        passed = 0,
        failed = 0,
    })

    print(colors("\n%{bright white}TOTAL: "..results.total.."    %{bright green}PASSED: "..results.passed.."     %{bright red}FAILED: "..results.failed.."\n "))
end

return {
    run = run
}

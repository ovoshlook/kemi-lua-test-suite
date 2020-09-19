TEST = true

if arg then
    for i=1,#arg do
        if arg[i] == "--stop-on-fail" then
            STOP_ON_FAIL = true
        end
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

local function splitString(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function kemi_test_print_table(t) 
    for k,v in pairs(t) do
        print("key: "..k.."->value: "..tostring(v))
        if type(v)=="table" then kemi_test_print_table(v) end
    end
end

local function compareTables(t1,t2,ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
       local v2 = t2[k1]
       if v2 == nil or not compareTables(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
       local v1 = t1[k2]
       if v1 == nil or not compareTables(v1,v2) then return false end
    end
    return true
 end

local function replaceLuaNotation(base,path,level,target,replacer)
    
    if not base[path[level]] then
       -- print(colors("%{magenta}"..path[level].."%{reset} not exists in %{bright blue}_G%{reset}, creating it..."))
        base[path[level]] = {}
    end
    if level < #path then
        return replaceLuaNotation(base[path[level]],path,level+1,target,replacer)
    end

    local saved
    if base[path[level]][target] then
        saved = base[path[level]][target] 
    else 
        base[path[level]][target] = nil
        saved = base[path[level]][target]
    end
    base[path[level]][target] = replacer
    return saved
    
end

local function replaceFSNotation(base,path,target,replacer)
    local saved 
    if not base[path] then
        --print(colors("%{magenta}"..path.."%{reset} not exists in %{bright blue}package.loaded%{reset}, creating it..."))
        base[path] = {}
    end
    if base[path][target] then
        saved = base[path][target]
    end
    base[path][target] = replacer
    return saved
end

local function replaceModule(path,target,replacer)
    
    --try to remove *.lua extention
    local moduleName = string.match(path,("([%w_%/]+)%.lua"))
    
    if not moduleName then
        -- if no extention then moduleName the same with path
        moduleName = path
    end

    -- convert possible a/b/c to a.b.c
    moduleName = string.gsub(moduleName,"%/",".")

    -- splitting path to array
    local moduleNameByPeaces = splitString(moduleName,".")
    local savedLuaNotation = replaceLuaNotation(_G,moduleNameByPeaces,1,target,replacer.luaNotation)
    local savedFSNotation = replaceFSNotation(package.loaded,moduleName,target,replacer.FSNotation)

    return {
        luaNotation = savedLuaNotation,
        FSNotation = savedFSNotation
    }
    
end

local mocking = {
    
    define = function (mocks)
  
        if not mocks then return nil end
        local mocked = {}
        for i=1,#mocks do
            local module = mocks[i].module
            local target = mocks[i].target
            local replacer = mocks[i].replacer
            print(colors("%{bright white}Mocking %{reset}%{magenta}\""..module..".%{yellow}"..target.."\"..."))
            local original = replaceModule(module,target,{ luaNotation = replacer, FSNotation = replacer })
            table.insert(mocked,{module = module, target = target, original = original })
                
        end

        return mocked
    end,
    restore = function (mocked)
    
        if not mocked then return end
        for i=1,#mocked do
            replaceModule(mocked[i].module,mocked[i].target,mocked[i].original)
        end
    end

}

local function testedFunctionInit(testedModule,testedFunction)
    if not testedModule then
        return _G[testedFunction]
    elseif not package.loaded[testedModule] then
        print(testedModule)
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

            local res = { testScenario.testedFunction( unpack(testScenario.testedFunctionArgs) ) }
            
            if not res and type(testScenario.expectedResult) == "table" then
                res = {}
            end
            
            local expectedRes = testScenario.expectedResult
            
            local comparedRes
            
            if type(expectedRes)~="table" then
                
                res = res[1]
                comparedRes = json.encode(res) == json.encode(expectedRes)
           
            else 
                
                comparedRes = compareTables(expectedRes,res)
            
            end
            
            if comparedRes then
                return true,res
            end

            return false,res
        end
    end,

    notSame = function(testScenario)
        if testScenario.resultContainer then

            testScenario.testedFunction( unpack(testScenario.testedFunctionArgs) )
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

            local res = { testScenario.testedFunction( unpack(testScenario.testedFunctionArgs)) }

            if not res and type(testScenario.expectedResult) == "table" then
                res = {}
            end

            local expectedRes = testScenario.expectedResult
            
            local comparedRes
            if type(expectedRes)~="table" then
                
                res = res[1]
                comparedRes = json.encode(res) == json.encode(expectedRes)
           
            else 
                
                expectedRes = { expectedRes }
                comparedRes = compareTables(expectedRes,res)

                --reverting changes back
                res = res[1]
                expectedRes = expectedRes[1]
            
            end
            
            if comparedRes then
                return false,res
            end

            return true,res

        end
    end,
}

function beautify(this)
    if this == nil then
        return "nil"
    elseif this == true then
        return "true"
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
    local mocked = mocking.define(mocks)
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

    mocking.restore(mocked)

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

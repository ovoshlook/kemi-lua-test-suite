## About
`Kamailio lua test suite` is an instrument for testing LUA based kamailio configuration. It allows to create as unit tests as flow tests

## How it works
There is no supermagic: It simply runs scripts defined in testSuite

## Usage

- `loarocks install kemi-test-suite`

- Describe tests at the `tests` directory [description delow].

- init in the `file.lua`
```lua
local testSuite = require "kemi-test-suite.init"
local mymodule = require "mymodule"
```
- call `run()` function
```lua
...

testSuite.run()
```
- also it is possible to call functions directly from the modules
```lua
testMySuperFunc = {
    description = "runs my super function",
    testedModule = "path/myPerfectModule.lua", --this path can be relative. the root path is a path where your main lua file exist: the one included in modparam("app_lua","load","/path/to/main/file.lua")
    testedFunction = "mySuperFunc"
}
```

## Usage
The main trigger which says to call testSuite or not is an environment variable `KAMAILIO_TESTSUITE_LUA`
It must to be defined in whatever environment testSuite will run
The simplest way to run it
```bash
export KAMAILIO_TESTSUITE_LUA=1 && lua file.lua
```
but it is better for this env variable to be switched off after tests otherwise when kamailio will be started it will run testSuite during runtime.
The best option is to run tests in the docker container.

`docker` folder with an example of the docker container that can be used to run tests is in the docker directory

## Tests description
```lua
return {
    mySuperTest = {
        description = "Test mymymodule",            -- Description of the test.                                 REQUIRED
        testedModule = "mymodule.lua"               -- Path to of the module contains testedFunction
        testedFunction = "func",                    -- Function being tested. kamailio here is a global         REQUIRED
                                                    -- if function is global like ksr_requrest_route 
                                                    -- no testedModule param needed.
        expectedResult = "a",                       -- Expected result of tested function
        resultContainer = { "$avp", "result" },     -- If function puts some value into the vp result 
                                                    -- container describes for testSuite where to find 
                                                    -- the result
        algorithm = 'same',                         -- Algo test will be running: same/notSame                  DEFAULT: same
        withParams = {                              -- Params will be passed into mock instead of defaults
            internalLogging = true,                 -- allows to see log messages inside tested functions       DEFAULT: false
            rm = "INVITE",
            si = "1.2.3.4",
            sp = "5060",
            du = "sip:5.6.7.8:12303",
            dp = "12303",
            ct = "123456@1.2.3.4:5060",
            ci = "44444",
            fu = "test1@bla",
            ft = "testtag",
            ru = "callee@foo",
            cs = 1,
            mocks = {                               -- Allows to redefine or define  behaviour of some functions
                                                    -- or just define it for the test if it not exists at all
                                                    -- it will be restored to original state after particular test runs
                                        
                {
                    module = "KSR.dispatcher",
                    target = "ds_select_dst",
                    replacer = function() return a end
                },
                {
                    module = "my/path/to/submodule.lua",
                    target = "myFunc",
                    replacer = function() return b end
                }
            }
        },
        testedFunctionArgs = {}                   -- Args has to be passed into tested function
    },
}
```
## Startup keys
`--stop-on-fail` will stop whole testsuite if one of the tests fails

## Management
there are some extensions that can be used for manage some test things:

- It is possible to use lua global variable which initializes everytime tests running named `TEST` for the specific cases in the lua code like:
```lua
ksr_request_route() 
    ...
    if TEST then
        return "auth success"
    end

    KSR.registrar.save(location,URI)
end
```

## Contributing or adding your own mocks for modules
- kemi-test-suite contains mocks, which contains modules. When you going to add new module - check dock of this module at the in the `https://kamailio.org/docs/modules/5.!!!**X**!!!.x/modules/` to understand parameters for this particular function. 
- if function of the module has required parameters: use `KAMAILIO_CRASH_CHECK(debug.getinfo(1),numOfParams,param1,param2)`. It will protect from the call of the function without required params, because it will crash kamailio during real runtime. Call of this function and will stop testing with the notification about it.
example **http_async_client.query** mock:
```lua
    local function query(query,callbackName) 
    KAMAILIO_CRASH_CHECK(debug.getinfo(1),2,query,callbackName)
    return 1
end
```
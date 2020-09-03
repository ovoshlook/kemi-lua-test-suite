## About
`Kamailio lua test suite` is an instrument for testing LUA based kamailio configuration. It allows to create as unit tests as flow tests

## How it works
There is no supermagic: It simply runs scripts defined in testSuite

## Initialiaztion
It is simple to use:

- clone it from git and near `*.lua` file which defined in
`modparam("app_lua","load","/path/to/main/example-kamailio.lua")`

- Describe tests at the `tests` directory [description delow].

- init in the `file.lua`
```lua
local testSuite = require "testSuite.init"
local mymodule = require "mymodule"
```
- call `run()` function
```lua
...
--[[
    this function can receive 1 parameter: it is a table of modules that was described as local modules but contain functions that also has to be tested
]]
testSuite.run({ mymodule = mymodule })
```

## Usage
The main trigger which says to call testSuite or not is an environment variable `KAMAILIO_TESTSUITE_LUA`
It must to be defined in whatever environment testSuite will run
The simplest way to run it
```bash
export KAMAILIO_TESTSUITE_LUA=1 && lua file.lua
```
but it is better to be switched off after tests. Otherwise when kamailio will be started it will run testSuite during runtime.
The best option is to run tests in the docker container.

There is a `docker` folder with an example of the docker container that can be used to run tests

## Tests description
```lua
return {
    mySuperTest = {
        description = "Test mymymodule",            -- Description of the test.                                 REQUIRED
        testedFunction = kamailio.mymodule.func,    -- Function being tested. kamailio is a global              REQUIRED
                                                    -- var where mincluded modules will be pointed
                                                    -- functions like like ksr_requrest_route has 
                                                    -- to be called directly.
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
            mocks = {                               -- Allows to redefine some functions that has been added int _G
                                                    -- Or not exists here. For example - rewriting of some KSR functions
                {
                    what = { "KSR","dispatcher","ds_select_dst" },
                    to = function() return a end
                }
            }
        },
        testedFunctionArgs = {}                   -- Args has to be passed into tested function
    },
}
```
## Startup keys
`--stop-on-fail` will stop whole testsuite

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
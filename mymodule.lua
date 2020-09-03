local  function testfunction1() 
    KSR.log("mymodule output testfunction1")
end

local  function testfunction2() 
    KSR.log("mymodule output testfunction2")
    return {a=1,b=2}
end

local mymodule = {
    testfunction1 = testfunction1,
    testfunction2 = testfunction2
}

return mymodule
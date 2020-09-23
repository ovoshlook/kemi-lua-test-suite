return {
    jsonrpc_exec_dispatcer_add = {
        description = "tests jsronrpc_command",
        testedModule = "jsonrpcsCall.lua",
        testedFunction = "call",
        withParams = {
            internalLogging = true
        }
    }
}
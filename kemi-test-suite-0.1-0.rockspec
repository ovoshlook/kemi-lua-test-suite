package = "kemi-test-suite"
version = "0.1-0"
source = {
   url = "git+https://github.com/ovoshlook/kemi-lua-test-suite.git",
   tag = "v0.1"
}
description = {
    summary = "test suite for the kamailio KEMI Lua engine ",
    detailed = [[
test suite for the kamailio KEMI Lua engine. End2End tests emulation & unit testing.
    ]],
    homepage = "https://github.com/ovoshlook/kemi-lua-test-suite",
    license = "MIT/X11"
}
dependencies = {
  "lua ~> 5.1",
  "lua-cjson ~> 2.1"
}
build = {
    type = "builtin",
    type = "command",
    install_command = "cp -r test-suite /usr/local/share/lua/5.1/kemi-test-suite"
}
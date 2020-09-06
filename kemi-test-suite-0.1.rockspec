package = "kemi-test-suite"
version = "0.1"
source = {
   url = "git+https://github.com/ovoshlook/kemi-lua-test-suite.git"
}
description = {
   homepage = "https://github.com/ovoshlook/kemi-lua-test-suite",
   license = "MIT"
}
dependencies = {
  "lua ~> 5.1"
  "lua-cjson ~> 2.1"
}
build = {
    type = "builtin",
    type = "command",
    install_command = "cp -r testSuite /usr/local/share/lua/5.1/test-suite"
}
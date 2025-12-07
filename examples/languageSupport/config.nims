# begin Nimble config (version 2)
when withDir(thisDir(), fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

# Project configuration for better language server performance
#[ switch("path", "$projectDir/src")
switch("hints", "off")
switch("warnings", "off") ]#

# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import languageSupport/submodule
import std/strutils
import arraymancer

when isMainModule:
  echo(getWelcomeMessage())
  echo(getWelcomeMessage().toUpperAscii())

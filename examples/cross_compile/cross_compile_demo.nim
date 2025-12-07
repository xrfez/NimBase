# Cross-Compilation Demo
# This program demonstrates platform detection and cross-compilation
# It can be compiled for Windows, Linux, and macOS from the same source

import std/[os, strformat]

proc getPlatformInfo(): string =
  ## Returns information about the current platform
  when defined(windows):
    result = "Windows"
  elif defined(linux):
    result = "Linux"
  elif defined(macosx):
    result = "macOS"
  else:
    result = "Unknown"
  
  when defined(amd64):
    result &= " (x86_64)"
  elif defined(i386):
    result &= " (x86)"
  elif defined(arm64):
    result &= " (ARM64)"
  elif defined(arm):
    result &= " (ARM)"
  else:
    result &= " (Unknown Architecture)"

proc main() =
  echo "========================================="
  echo "  Cross-Compilation Demo"
  echo "========================================="
  echo ""
  echo fmt"Compiled for: {getPlatformInfo()}"
  echo fmt"Host OS: {hostOS}"
  echo fmt"Host CPU: {hostCPU}"
  echo ""
  
  # Show some platform-specific features
  when defined(windows):
    echo "Windows-specific features available:"
    echo "  - Windows API"
    echo "  - .exe executable format"
    echo "  - Backslash path separators"
  elif defined(linux):
    echo "Linux-specific features available:"
    echo "  - POSIX API"
    echo "  - ELF executable format"
    echo "  - Forward slash path separators"
  elif defined(macosx):
    echo "macOS-specific features available:"
    echo "  - Cocoa/Darwin API"
    echo "  - Mach-O executable format"
    echo "  - Forward slash path separators"
  
  echo ""
  echo "Current directory:", getCurrentDir()
  echo "========================================="

when isMainModule:
  main()

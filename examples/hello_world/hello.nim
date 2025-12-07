# Hello World - Nim Example

import std/strformat

proc greet(name: string): string =
  ## Returns a greeting message
  ## 
  ## Args:
  ##   name: The name of the person to greet
  ## 
  ## Returns:
  ##   A formatted greeting string
  fmt"Hello, {name}! Welcome to Nim programming."

proc main() =
  ## Main entry point
  echo "======================================"
  echo "  Nim Hello World Example"
  echo "======================================"
  echo ""
  
  # Basic greeting
  echo greet("Developer")
  
  # Show some Nim features
  echo ""
  echo "Nim Compiler Version: ", NimVersion
  echo "Nim Major Version: ", NimMajor
  echo "Nim Minor Version: ", NimMinor
  echo "Nim Patch Version: ", NimPatch
  
  # Show available backends
  echo ""
  echo "Available compiler backends:"
  echo "  - C (default)"
  echo "  - C++ (--cc:cpp)"
  echo "  - JavaScript (--backend:js)"
  echo "  - Objective-C (--backend:objc)"
  
  echo ""
  echo "======================================"

# Run main when executed as script
when isMainModule:
  main()

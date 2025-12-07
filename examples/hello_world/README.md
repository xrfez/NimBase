# Hello World Example

A simple Nim program demonstrating basic syntax and compilation.

## Building

```bash
# Compile only
nim c hello.nim

# Compile and run
nim c -r hello.nim

# Release build (optimized)
nim c -d:release hello.nim

# Using Clang compiler
nim c --cc:clang hello.nim
```

## Output

```
======================================
  Nim Hello World Example
======================================

Hello, Developer! Welcome to Nim programming.

Nim Compiler Version: 2.0.x
Nim Major Version: 2
Nim Minor Version: 0
Nim Patch Version: x

Available compiler backends:
  - C (default)
  - C++ (--cc:cpp)
  - JavaScript (--backend:js)
  - Objective-C (--backend:objc)

======================================
```

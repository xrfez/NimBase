#!/bin/bash
# Build script for cross-compilation demo
# Compiles the demo for multiple platforms

set -e

echo "======================================"
echo "  Cross-Compilation Build Script"
echo "======================================"
echo ""

# Create dist directory
mkdir -p dist

echo "Building for Linux (native)..."
nim c -d:release -o:dist/cross_compile_demo_linux_amd64 cross_compile_demo.nim

echo "Building for Windows (x64)..."
nim c --os:windows --cpu:amd64 -d:mingw -d:release -o:dist/cross_compile_demo_windows_amd64.exe cross_compile_demo.nim

echo "Building for Windows (x86)..."
nim c --os:windows --cpu:i386 -d:mingw -d:release -o:dist/cross_compile_demo_windows_i386.exe cross_compile_demo.nim

echo "Building for macOS (Intel)..."
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:amd64 -d:release \
  -o:dist/cross_compile_demo_macos_amd64 cross_compile_demo.nim

echo "Building for macOS (Apple Silicon)..."
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:arm64 -d:release \
  -o:dist/cross_compile_demo_macos_arm64 cross_compile_demo.nim

echo ""
echo "======================================"
echo "  Build Complete!"
echo "======================================"
echo ""
echo "Executables created in dist/:"
ls -lh dist/
echo ""
echo "You can now copy these executables to their target platforms."

# Cross-Compilation Example

This example demonstrates how to compile Nim code for different platforms from the Linux container.

## Files

- `cross_compile_demo.nim` - A simple program that shows platform information

## Building for Different Platforms

### Linux (Native)

```bash
# Standard compilation
nim c cross_compile_demo.nim
./cross_compile_demo

# Release build
nim c -d:release cross_compile_demo.nim
```

### Windows

```bash
# Using MinGW (recommended)
nim c --os:windows --cpu:amd64 -d:mingw cross_compile_demo.nim

# Using Zig
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:windows --cpu:amd64 cross_compile_demo.nim

# 32-bit Windows
nim c --os:windows --cpu:i386 -d:mingw cross_compile_demo.nim

# Output: cross_compile_demo.exe
```

### macOS

```bash
# Intel Mac
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:amd64 cross_compile_demo.nim

# Apple Silicon (M1/M2)
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:arm64 cross_compile_demo.nim
```

### ARM Linux (e.g., Raspberry Pi)

```bash
# ARM 32-bit
nim c --os:linux --cpu:arm cross_compile_demo.nim

# ARM 64-bit
nim c --os:linux --cpu:arm64 cross_compile_demo.nim
```

## Build Script

You can also use the provided build script to compile for all platforms:

```bash
bash build_all.sh
```

This will create executables in the `dist/` directory for all supported platforms.

## Testing

After cross-compiling:

1. **Windows .exe**: Copy to a Windows machine and run
2. **macOS binary**: Copy to a Mac and run (may need `chmod +x`)
3. **Linux binary**: Run directly in the container or copy to another Linux system

## Notes

- **MinGW** is the most reliable for Windows cross-compilation
- **Zig** provides broader platform support including macOS
- Some platform-specific libraries may not work when cross-compiling
- Always test on the target platform when possible
- For GUI applications, consider platform-specific dependencies

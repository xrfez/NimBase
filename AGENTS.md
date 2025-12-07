# NimBase - Nim Development Container

## Project Overview

A production-ready, fully-featured Docker development environment for the Nim programming language. Designed for Windows 11 + WSL2 users, with seamless VS Code Dev Containers integration.

## ✅ Implemented Features

### Core Components
- **Nim Compiler**: v2.2.6 installed via [grabnim](https://codeberg.org/janAkali/grabnim) from Codeberg
- **Package Managers**: Nimble and Atlas fully configured
- **Language Server**: nimlangserver v1.12.0 for IDE features
- **Code Formatter**: NPH (Nim Pretty Hacker) for auto-formatting
- **Shell**: Zsh with Oh My Posh (markbull theme)

### Development Tools
- **Compilers**: GCC, Clang, LLVM toolchain, TCC, MinGW-w64 (x86/x64), Zig 0.13.0
- **Debuggers**: GDB, LLDB, Valgrind, strace
- **Build Tools**: Make, CMake
- **JavaScript**: Node.js with npm, Bun with built-in package manager
- **Modern CLI**: ripgrep, fd, bat, fzf, eza, neovim, tmux, htop, jq
- **Docker-in-Docker**: Full Docker CLI access to host daemon
- **C Interop**: libclang-dev for Futhark support

### VS Code Integration
- **Extensions**: nimlang.nimlang, Docker, GitLens pre-installed
- **LSP Features**: Auto-complete, go-to-definition, hover info, error detection
- **Format on Save**: Automatic NPH formatting
- **Shell Integration**: Enhanced terminal with command tracking
- **Font**: MesloLGM Nerd Font configured
- **File Associations**: `.nim`, `.nims`, `.nimble` properly configured
- **File Watcher Exclusions**: `.nimble`, `.cfg`, `.paths` excluded to prevent LSP crashes

### Cross-Compilation
- **Windows**: MinGW-w64 (x86_64-w64-mingw32-gcc)
- **Windows/macOS/Linux**: Zig compiler (zigcc)
- **Tested**: All cross-compilation targets verified working

### Git & SSH Integration
- **SSH Keys**: Auto-mounted from Windows `~/.ssh` (read-only)
- **Git Config**: Auto-mounted from Windows `~/.gitconfig` (user.name, user.email)
- **Permissions**: Automatic chmod 600 on SSH keys via postCreateCommand

### Container Architecture
- **Base Image**: Debian Bookworm Slim
- **Shell**: Zsh (default), Bash available
- **Workspace**: `/projects/NimBase` (parent directory mounted to `/projects`)
- **Persistent Volumes**:
  - `nim-dev-nimble-cache` - Package cache
  - `nim-dev-nim-cache` - Compiler cache
  - `nim-dev-bash-history` - Bash history
  - `nim-dev-zsh-config` - Zsh customizations (.zshrc.local)
- **Port Forwarding**: 8080, 3000 pre-configured

## 🎯 Design Principles

### Flexibility
- **Clone Anywhere**: Can be cloned to any directory on Windows
- **Parent Mount**: Automatically mounts parent directory for sibling project access
- **Customizable Mounts**: Easy to configure different mount points in docker-compose.yml

### Best Practices
- **Docker Standards**: Proper Dockerfile, docker-compose.yml, .dockerignore
- **Volume Persistence**: Critical data persists across rebuilds
- **Commented Code**: All configuration files are thoroughly documented
- **No Hardcoded Paths**: Works regardless of clone location

### Community Ready
- **No Credentials**: No hardcoded usernames, emails, or paths
- **Comprehensive Docs**: README.md (full), QUICKSTART.md (reference), PUBLISHING.md
- **Example Projects**: hello_world, cross_compile with working demos

## 📝 Configuration Files

### Docker
- **Dockerfile**: Multi-stage build with all tools and configurations
- **docker-compose.yml**: Service definition with volumes, ports, networks
- **.dockerignore**: Optimized build context

### VS Code
- **.devcontainer/devcontainer.json**: Dev Container configuration with extensions, settings, mounts
- **File associations**: Proper language mappings for Nim files
- **Settings**: LSP configuration, format-on-save, font settings

### Nim
- **nim.cfg**: Project-level compiler configuration for LSP performance
- **config.nims**: Build configuration (optional)
- **.nimble files**: Package metadata (associated with 'nim' language)

### Shell
- **Oh My Posh**: markbull theme configured for modern prompt
- **.zshrc_custom**: Custom Zsh configuration sourced on startup
- **/root/.zsh_persistent/.zshrc.local**: User customizations (in volume)

## 🔧 Technical Details

### Compiler Testing
All documented compiler backends have been tested and verified:
- ✅ GCC (default) - Full functionality
- ✅ Clang - Full functionality  
- ✅ TCC - Works with `--threads:off` flag
- ✅ MinGW - Successful Windows .exe generation
- ❌ MSVC - Not supported (requires Nim on Windows host)
- ❌ LLD linker - Not compatible with Nim's build system

### Known Issues & Solutions
- **TCC Threading**: Requires `--threads:off` flag (documented in README and QUICKSTART)
- **nimlangserver Stability**: Excludes `.nimble`, `.cfg`, `.paths` from file watcher to prevent crashes
- **SSH Permissions**: Automatically fixed to 600 via postCreateCommand
- **Line Endings**: Git configured for proper CRLF handling in Windows/WSL environment

## 📂 Directory Structure

```
NimBase/
├── .devcontainer/
│   └── devcontainer.json
├── examples/
│   ├── hello_world/
│   └── cross_compile/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── QUICKSTART.md
├── PUBLISHING.md
├── STATUS.md
└── AGENTS.md (this file)
```

## 🚀 Usage Patterns

### Primary Workflow
1. Clone NimBase to any directory on Windows
2. Open in VS Code
3. F1 → "Dev Containers: Reopen in Container"
4. Start coding with full IDE support

### Alternative Workflow
1. `docker-compose up -d`
2. `docker-compose exec nim-dev zsh`
3. Work in `/projects/NimBase`

## 🎓 Philosophy

**Goal**: Provide a zero-configuration, batteries-included Nim development environment that:
- Works consistently across different machines
- Requires no manual setup beyond Docker + VS Code
- Follows Docker and Nim community best practices
- Serves as both a development tool and educational resource
- Can be easily adapted for other projects/languages

**Non-Goals**:
- MSVC support (requires host Nim installation)
- Windows container variant (Linux container works perfectly on Windows via WSL2)
- Pre-configured IDE distributions (Neovim is minimal, users can customize)

## 📊 Project Status

**Current State**: Production-ready, fully functional, documented, and tested.

**Maintenance**: All examples verified, all compiler backends tested, documentation accurate.

**Community**: Ready for public use and contribution.     

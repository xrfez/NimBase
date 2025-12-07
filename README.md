# Nim Development Environment with Docker

A complete, plug-and-play Docker-based development environment for the Nim programming language. This setup provides a consistent development experience across different machines and integrates seamlessly with VS Code's Dev Containers extension.

## 🎯 Features

- **Nim Compiler**: Latest stable version via [grabnim](https://codeberg.org/janAkali/grabnim)
- **Language Server**: nimlangserver for IDE features (autocomplete, go-to-definition, etc.)
- **Code Formatter**: NPH (Nim Pretty Hacker) for automatic code formatting
- **Compilers**: GCC, Clang, LLVM (with full toolchain), TCC, Zig, and MinGW
- **Build Tools**: CMake, Make, LLD (LLVM linker) for project building
- **Cross-Compilation**: Build for Windows, Linux, and macOS from the same container
- **JavaScript Ecosystem**: Node.js with npm and Bun (with built-in package manager)
- **Package Manager**: Nimble and Atlas for dependency management
- **Docker-in-Docker**: Run Docker commands inside the container for databases, services, etc.
- **Modern CLI Tools**: ripgrep, fd, bat, fzf, eza for enhanced productivity
- **Text Editors**: Neovim with Nim LSP support and sensible defaults
- **Terminal Tools**: tmux with mouse support and vi-style keybindings
- **Debugging Tools**: GDB, LLDB, Valgrind, strace for comprehensive debugging
- **VS Code Integration**: Full Dev Containers support with recommended extensions
- **Persistent Storage**: Volumes for package cache and bash history
- **Git Integration**: Automatic SSH key and credential sharing from Windows host
- **Oh My Posh**: Modern cross-platform prompt theme engine with markbull theme

## 📋 Prerequisites

### Required
- **Windows 11** with WSL2 installed
- **Docker Desktop** for Windows (with WSL2 backend enabled)
- **VS Code** with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Recommended (for best terminal experience)
- **Nerd Font** installed on Windows for proper Oh My Zsh theme rendering
  - Download: [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
  - Popular choices: FiraCode Nerd Font, MesloLGS NF, Hack Nerd Font
  - Install on Windows, then configure VS Code to use it

### Optional
- Git for version control
- Basic knowledge of Docker and containers

## 🚀 Quick Start

### Easiest Way to Get Started

1. **Clone the repository** (anywhere on your Windows system):
   ```powershell
   cd D:\MyProjects  # Or any directory you prefer
   git clone https://github.com/xrfez/NimBase.git
   cd NimBase
   ```

2. **Open in VS Code**:
   ```powershell
   code .
   ```

3. **Reopen in container**:
   - Press `F1`
   - Type and select: `Dev Containers: Reopen in Container`
   - Wait for build (5-10 minutes first time)

4. **Start coding!**
   - Open terminal (`` Ctrl+` ``)
   - You're in a fully configured Nim environment at `/projects/NimBase`

### Clone Location Flexibility

You can clone this repository **anywhere** on your system. The container will automatically mount the parent directory, giving you access to sibling projects:

```powershell
# Example locations:
#   C:\Users\YourName\Dev\NimBase
#   D:\Programming\NimBase
#   E:\Projects\Docker\NimBase
```

The container mounts the **parent directory** to `/projects`, so you'll have access to:
- NimBase at `/projects/NimBase` (workspace folder)
- Any other projects in the parent directory at `/projects/OtherProject`

### Option 1: Using VS Code Dev Containers (Recommended)

1. **Navigate to the NimBase directory**:
   ```powershell
   cd path\to\NimBase
   ```

2. **Open in VS Code**:
   ```powershell
   code .
   ```

3. **Reopen in Container**:
   - Press `F1` to open the command palette
   - Type and select: `Dev Containers: Reopen in Container`
   - Wait for the container to build (first time takes 5-10 minutes)
   - VS Code will reload inside the container

4. **Start coding**:
   - Open the integrated terminal (`` Ctrl+` ``)
   - You're now in a fully configured Nim environment!

### Option 2: Using Docker Compose Directly

1. **Build and start the container**:
   ```powershell
   docker-compose up -d
   ```

2. **Enter the container**:
   ```powershell
   docker-compose exec nim-dev zsh
   ```

3. **Verify installation**:
   ```bash
   nim --version
   nimble --version
   nimlangserver --version
   nph --version
   zig version
   x86_64-w64-mingw32-gcc --version
   bun --version
   ```

## 📁 Project Structure

```
NimBase/
│
├── .devcontainer/
│   └── devcontainer.json         # VS Code Dev Container configuration
│
├── examples/
│   ├── hello_world/              # Basic Nim example
│   │   ├── hello.nim
│   │   └── README.md
│   └── cross_compile/            # Cross-compilation examples
│       ├── cross_compile_demo.nim
│       ├── build_all.sh
│       └── README.md
│
├── Dockerfile                    # Docker image definition
├── docker-compose.yml            # Docker Compose orchestration
├── .dockerignore                 # Files to exclude from Docker context
├── .editorconfig                 # Editor configuration
├── README.md                     # This file (comprehensive guide)
├── QUICKSTART.md                 # Quick reference guide
├── PUBLISHING.md                 # Docker Hub publishing guide
├── STATUS.md                     # Implementation status
└── AGENTS.md                     # Project requirements and specifications

# Persistent Data (Docker Volumes):
# - nim-dev-nimble-cache          # Nim package cache
# - nim-dev-nim-cache             # Nim compiler cache
# - nim-dev-bash-history          # Bash history
# - nim-dev-zsh-config            # Zsh customizations (.zshrc.local)
```

## 🛠️ Usage Guide

### Creating a New Nim Project

Inside the container (or Dev Container terminal):

```bash
# Navigate to your projects directory
cd /projects

# Initialize a new nimble project (interactive)
nimble init

# Follow the prompts to configure:
# - Package name
# - Package type (library/binary/hybrid)
# - Author name
# - Description
# - License
# - Nim version

# The project structure will be created with:
# - src/          (source code)
# - tests/        (unit tests)
# - yourproject.nimble  (package metadata)
```

### Managing Dependencies

**Important**: Always specify versions in your `.nimble` file to avoid dependency resolution issues with Nimble's SAT solver.

```nim
# In yourproject.nimble - GOOD (with versions)
requires "nim >= 2.0.0"
requires "jester >= 0.6.0"
requires "asynctools >= 0.1.1"

# BAD (no versions) - can cause solver issues
requires "jester"
requires "asynctools"
```

After adding dependencies to your `.nimble` file:

```bash
# Install all dependencies from .nimble file
nimble install

# Or use setup to install dependencies and compile
nimble setup

# Search for packages
nimble search <query>

# Install a specific package
nimble install jester@0.6.0
```

### Compiling and Running Nim Code

```bash
# Compile a Nim file
nim c myprogram.nim

# Compile and run
nim c -r myprogram.nim

# Compile with optimizations (release mode)
nim c -d:release myprogram.nim

# Use a specific compiler backend
nim c --cc:clang myprogram.nim
nim c --cc:gcc myprogram.nim
nim c --cc:tcc --threads:off myprogram.nim  # TCC requires --threads:off

# Use LLVM C++ standard library
nim cpp --cc:clang --clang.options.linker="-lc++" myprogram.nim
```

### Cross-Compilation

The container includes MinGW and Zig for cross-platform compilation:

#### Compile for Windows from Linux

```bash
# Using MinGW (recommended for Windows targets)
nim c --os:windows --cpu:amd64 -d:mingw myprogram.nim

# Using Zig (alternative, supports more targets)
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:windows --cpu:amd64 myprogram.nim

# The output will be myprogram.exe (Windows executable)
```

#### Compile for macOS from Linux

```bash
# Using Zig for macOS cross-compilation
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:amd64 myprogram.nim

# For ARM-based Macs (M1/M2)
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc \
  --os:macosx --cpu:arm64 myprogram.nim
```

#### Compile for different architectures

```bash
# 32-bit Windows
nim c --os:windows --cpu:i386 -d:mingw myprogram.nim

# ARM Linux (e.g., Raspberry Pi)
nim c --os:linux --cpu:arm myprogram.nim

# ARM64 Linux
nim c --os:linux --cpu:arm64 myprogram.nim
```

### JavaScript Development with Bun

Bun provides a fast package manager and runtime:

```bash
# Initialize a new project
bun init

# Install packages
bun install <package-name>

# Run a script
bun run script.js

# Use bunx to run packages without installing
bunx <package-name>
```

### Code Formatting

```bash
# Format a file using NPH
nph myfile.nim

# Format all .nim files in current directory
find . -name "*.nim" -exec nph {} \;
```

### Modern CLI Tools

The container includes modern CLI tools to improve your development workflow:

#### File Search & Navigation
```bash
# ripgrep (rg) - Fast code search
rg "function_name" --type nim        # Search in Nim files
rg -i "pattern"                      # Case-insensitive search

# fd - Fast file finder (alternative to find)
fd main.nim                          # Find files by name
fd -e nim                            # Find all .nim files

# fzf - Fuzzy finder
history | fzf                        # Search command history
fd | fzf                             # Fuzzy file search
```

#### File Viewing & Editing
```bash
# bat - Cat with syntax highlighting
bat myfile.nim                       # View file with syntax colors
bat -A myfile.nim                    # Show all characters

# eza - Modern ls replacement
eza -l                               # Better file listing
eza --tree --level=2                 # Tree view with depth
eza -la --git                        # Show git status

# neovim - Modern text editor
nvim myfile.nim                      # Edit file in neovim
```

#### Terminal Management
```bash
# tmux - Terminal multiplexer
tmux                                 # Start new session
tmux attach                          # Attach to existing session
```

### Neovim Key Bindings

Minimal sensible configuration included. Leader key is **Space**.

#### Basic Navigation
- `Space + e` - Open file explorer
- `Ctrl+h/j/k/l` - Move between windows (left/down/up/right)
- `Space + w` - Save file
- `Space + q` - Quit
- `Esc` - Clear search highlighting

#### LSP Features (Nim files)
- `gd` - Go to definition
- `K` - Show hover information
- `Space + rn` - Rename symbol
- `Space + ca` - Code actions

**Note**: For full IDE features, consider installing [LazyVim](https://www.lazyvim.org/) or your preferred Neovim distribution.

**Important**: The language server is configured to exclude certain Nim configuration files (`*.nimble`, `*.cfg`, `*.paths`) from file watching to prevent crashes. These files are still readable by nimlangserver for project configuration, but changes won't trigger automatic re-parsing. This is set via `files.watcherExclude` in the devcontainer settings.

### Tmux Key Bindings

Prefix key is **Ctrl+a** (instead of default Ctrl+b).

#### Session Management
- `Ctrl+a d` - Detach from session
- `Ctrl+a r` - Reload tmux config

#### Window & Pane Management
- `Ctrl+a |` - Split pane vertically
- `Ctrl+a -` - Split pane horizontally
- `Ctrl+a arrow-key` - Navigate between panes
- Mouse support is enabled for clicking and resizing

#### Copy Mode (Vi-style)
- `Ctrl+a [` - Enter copy mode
- `v` - Begin selection
- `y` - Copy selection
- `Ctrl+a ]` - Paste

### Debugging

```bash
# Compile with debug symbols
nim c --debugger:native myprogram.nim

# Debug with GDB (for GCC-compiled binaries)
gdb ./myprogram

# Debug with LLDB (for Clang/LLVM-compiled binaries)
lldb ./myprogram

# Memory debugging with Valgrind
valgrind --leak-check=full ./myprogram

# System call tracing with strace
strace -o trace.log ./myprogram

# Compile with line number information
nim c --lineDir:on myprogram.nim
```

## 🐳 Docker-in-Docker Support

The container includes Docker CLI and access to the host Docker daemon, allowing you to run Docker commands inside the dev environment.

### Using Docker Inside the Container

```bash
# Check Docker is available
docker --version
docker compose version

# Run a PostgreSQL database for your project
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=mysecret \
  -p 5432:5432 \
  postgres:latest

# Run Redis
docker run -d --name redis \
  -p 6379:6379 \
  redis:latest

# Use docker compose for multi-service projects
cd my_project
cat > docker-compose.yml << EOF
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
  redis:
    image: redis:7
    ports:
      - "6379:6379"
EOF

docker compose up -d
```

### Multi-Language Project Example

```bash
# Your project might need Python for data processing
docker run -it --rm -v $(pwd):/app python:3.11 python /app/process_data.py

# Or Node.js for frontend build
docker run -it --rm -v $(pwd):/app node:20 npm install
```

### Building Docker Images from Nim Projects

```bash
# Create a Dockerfile for your Nim application
cat > Dockerfile << EOF
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl3
COPY myapp /usr/local/bin/
CMD ["myapp"]
EOF

# Build your Nim app as static binary
nim c -d:release --passL:-static myprogram.nim

# Build Docker image
docker build -t mynim-app .

# Run it
docker run -p 8080:8080 mynim-app
```

### Important Notes

- **Docker daemon runs on host**: Container uses host's Docker, not a separate daemon
- **Containers are siblings**: Containers you create run alongside this dev container
- **Port forwarding**: Ports published by containers started from inside the dev container are accessible on your Windows host
  - Example: If you run `docker run -p 5432:5432 postgres` inside the container, PostgreSQL will be accessible at `localhost:5432` on Windows
  - The dev container itself already forwards ports 8080 and 3000 to the host
- **Network access**: Use `host.docker.internal` to access Windows host services from spawned containers
- **Resource sharing**: All containers share host resources

## 🔑 Git Credentials & SSH

The container automatically shares Git credentials and SSH keys from your Windows host.

### What's Automatically Configured

- **SSH Keys**: Your `~/.ssh` directory is mounted (read-only)
- **Git Config**: Your `.gitconfig` is mounted (preserves user.name, user.email, aliases)
- **Git Operations**: Clone, push, pull work seamlessly with your existing credentials

**Important**: If you haven't configured Git on your Windows host, you'll need to set it up:

```bash
# On Windows host (PowerShell) - BEFORE starting container
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# OR inside the container - for container-only Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

The container automatically mounts `~/.gitconfig` from Windows, so configuring it on the host is recommended.

### Using Git

```bash
# Verify your Git identity is configured
git config user.name   # Shows your Git username
git config user.email  # Shows your Git email

# Clone private repositories using SSH
git clone git@github.com:username/private-repo.git

# Clone using HTTPS (uses Windows credentials)
git clone https://github.com/username/repo.git

# Normal Git operations work as expected
git add .
git commit -m "Update from container"
git push origin main
```

### SSH Key Setup (First Time Only)

If you don't have SSH keys on Windows yet:

```powershell
# On Windows host (PowerShell)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter for default location
# Add passphrase if desired

# Copy public key to clipboard
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
```

Then restart the container to pick up the new keys.

### HTTPS Credential Storage

For HTTPS Git operations:

```bash
# Inside container - store credentials (one-time)
git config --global credential.helper store

# Next time you clone/push with HTTPS, enter credentials once
# They'll be saved to ~/.git-credentials
```

### Troubleshooting Git Access

```bash
# Test SSH connection to GitHub
ssh -T git@github.com

# Test SSH connection to GitLab
ssh -T git@gitlab.com

# Check SSH key permissions (should be 600)
ls -la ~/.ssh/

# If permissions are wrong, they're read-only from host
# Fix on Windows host instead
```

### Using Multiple Git Accounts

If you use different Git accounts for different projects:

```bash
# Set per-project Git user
cd my_work_project
git config user.name "Work Name"
git config user.email "work@company.com"

cd ../my_personal_project
git config user.name "Personal Name"
git config user.email "personal@email.com"

- Or use SSH config on Windows host with different keys
```

## 🎨 Oh My Posh Configuration

The container comes with Oh My Posh pre-configured with the **markbull theme** for a modern, cross-platform prompt experience.

### Default Configuration

- **Shell**: Zsh (configured as default in Dev Containers)
- **Prompt**: Oh My Posh with markbull theme
- **Features**:
  - Git branch and status information
  - Current directory with path shortening
  - Command execution time
  - Exit code indicators
  - Nerd Font icon support

### Installing Nerd Fonts (Windows)

Oh My Posh requires a Nerd Font for proper icon display:

```powershell
# Download MesloLGM Nerd Font (recommended):
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip

# Or browse all fonts: https://www.nerdfonts.com/
# Popular choices:
# - MesloLGM Nerd Font (recommended)
# - FiraCode Nerd Font
# - Hack Nerd Font

# Install by double-clicking the .ttf file in Windows
```

The devcontainer is already configured to use MesloLGM Nerd Font. If you installed a different font, update `.devcontainer/devcontainer.json`:

```json
"terminal.integrated.fontFamily": "YourFont Nerd Font, monospace"
```

### Customizing Oh My Posh

**Change theme** (inside container):

```bash
# View available themes
oh-my-posh config export image

# List all themes
ls /usr/local/share/oh-my-posh/themes/

# Change theme temporarily (test it out)
oh-my-posh init zsh --config /usr/local/share/oh-my-posh/themes/agnoster.omp.json | source

# Make it permanent - edit .zshrc.local
nano /root/.zsh_persistent/.zshrc.local
# Add:
eval "$(oh-my-posh init zsh --config /usr/local/share/oh-my-posh/themes/YOUR_THEME.omp.json)"
```

**Popular themes**: `agnoster`, `atomic`, `blue-owl`, `bubblesextra`, `capr4n`, `catppuccin`, `clean-detailed`, `craver`, `dracula`, `gruvbox`, `jandedobbeleer`, `kushal`, `night-owl`, `paradox`, `powerlevel10k_rainbow`, `tokyo`

**⚠️ Note**: Changes to `~/.zshrc` inside the container are **lost on rebuild**.

### Persistent Customizations

For changes that survive container rebuilds, edit `.zshrc.local` **inside the container**:

```bash
# Inside the container, edit:
nano /root/.zsh_persistent/.zshrc.local
# Or use vim, nvim, etc.

# Example customizations:
# Add custom aliases
alias ll='eza -lah'
alias gs='git status'

# Add environment variables
export EDITOR=nvim

# Add custom functions
myfunction() {
    echo "Custom function"
}

# These changes persist across container rebuilds in a Docker volume!
```

The `.zshrc.local` file is stored in a Docker volume (`nim-dev-zsh-config`) and automatically sourced by `.zshrc` on startup.

**Migrating from old setup**: If you had customizations in `.devcontainer/.zshrc.local`, copy them to `/root/.zsh_persistent/.zshrc.local` inside the container.

### Built-in Shell Aliases

The container includes convenient aliases for Nim development:

```bash
# Nim compilation aliases
nimr <file.nim>       # Compile and run (nim c -r)
nimrel <file.nim>     # Release build (nim c -d:release)
nimcross <file.nim>   # Cross-compile for Windows x64 (MinGW)

# Examples
nimr hello.nim        # Quick compile and run
nimrel app.nim        # Optimized production build
nimcross tool.nim     # Creates tool.exe for Windows
```

**Full command equivalents:**
- `nimr` = `nim c -r`
- `nimrel` = `nim c -d:release`
- `nimcross` = `nim c --cpu:amd64 --os:windows --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc`

### Using Bash Instead

If you prefer bash over zsh:

```bash
# In container, switch to bash
bash

# Or set bash as default in .devcontainer/devcontainer.json
"terminal.integrated.defaultProfile.linux": "bash"
```

## 🔧 Customization

The container includes a comprehensive set of compilers and tools:

### Nim Ecosystem
- **Nim Compiler** - Latest stable version via grabnim
- **Nimble** - Package manager
- **Atlas** - Modern package manager
- **nimlangserver** - LSP for IDE integration
- **NPH** - Modern code formatter

### Version Control
- **Git** - Full Git CLI for version control
- **SSH** - Secure shell client for Git authentication
- **SSL/TLS** - Complete certificate support for HTTPS

### C/C++ Compilers
- **GCC** - GNU Compiler Collection (default)
- **Clang** - LLVM-based compiler
- **LLVM** - Low-level compiler infrastructure with full toolchain:
  - **llvm-dev** - LLVM development libraries
  - **lld** - LLVM linker (faster alternative to GNU ld)
  - **lldb** - LLVM debugger
  - **libc++** - LLVM C++ standard library
- **TCC** - Tiny C Compiler (fast compilation, requires `--threads:off` flag)
- **MinGW-w64** - Windows cross-compiler (both x86 and x64)

### Build Tools
- **Make** - Classic build automation
- **CMake** - Modern cross-platform build system

### Cross-Compilation Tools
- **Zig** - Modern compiler with excellent cross-compilation
- **zigcc** - Zig as a C/C++ compiler (supports Windows, macOS, Linux)

### JavaScript/TypeScript
- **Node.js** - JavaScript runtime
- **npm** - Node package manager
- **Bun** - Fast JavaScript runtime and package manager
- **bunx** - Execute npm packages without installing

### Supported Target Platforms
From this single Linux container, you can compile for:
- **Linux** (x86, x64, ARM, ARM64)
- **Windows** (x86, x64) via MinGW or Zig
- **macOS** (Intel x64, Apple Silicon ARM64) via Zig

## 🔧 Customization

### Adding System Packages

Edit the `Dockerfile` and add packages to the `apt-get install` command:

```dockerfile
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    your-new-package \
    && rm -rf /var/lib/apt/lists/*
```

Then rebuild:
```powershell
docker-compose up -d --build
```

### Customizing File System Access

By default, the container mounts the **parent directory** of NimBase to `/projects`, giving you access to sibling projects:

```
Host: D:\Programming\
  ├── NimBase\           → Container: /projects/NimBase (workspace)
  ├── OtherProject1\     → Container: /projects/OtherProject1
  └── OtherProject2\     → Container: /projects/OtherProject2
```

**To customize the mount**, edit `docker-compose.yml` **before** first start:

```yaml
volumes:
  # Current setup - mounts parent directory
  - type: bind
    source: ..
    target: /projects
  
  # Option 1: Mount entire D: drive
  - type: bind
    source: D:\
    target: /d
  
  # Option 2: Mount your user directory
  - type: bind
    source: ${USERPROFILE}
    target: /home
  
  # Option 3: Mount specific projects folder
  - type: bind
    source: D:\MyProjects
    target: /projects
```

**Important**: If you change the mount point, also update `workspaceFolder` in `.devcontainer/devcontainer.json` to match where NimBase will be located.

**After changing mounts**, recreate the container:
```powershell
docker-compose down
docker-compose up -d
# Or in VS Code: F1 → "Dev Containers: Rebuild Container"
```

### Customizing Installation Paths

You can customize where Nim and Zig are installed using build arguments:

```yaml
# In docker-compose.yml
services:
  nim-dev:
    build:
      args:
        NIMBASE: /usr/local/nim
        ZIGPATH: /usr/local/zig
```

Or when building directly:

```powershell
docker build --build-arg NIMBASE=/custom/nim --build-arg ZIGPATH=/custom/zig -t nim-dev .
```

The container automatically creates these directories and configures PATH correctly.

### Adding Nim Packages

Edit the `Dockerfile` and add to the nimble install section:

```dockerfile
RUN nimble install -y \
    asynctools \
    result \
    your-nim-package
```

Or install them manually inside the container (they'll persist in the volume).

### Adding VS Code Extensions

The container comes pre-configured with the Nim extension. To add more:

Edit `.devcontainer/devcontainer.json` and add extension IDs to the `extensions` array:

```json
"extensions": [
    "nimlang.nimlang",  // Pre-installed Nim extension
    "your.extension.id"
]
```

### VS Code Editor Features

The following features are pre-configured:

- **Auto-formatting on save** - Nim files automatically formatted with NPH when saved
- **Language Server Protocol** - Code completion, go-to-definition, hover info via nimlangserver
- **Error detection** - Real-time syntax and semantic error highlighting
- **Code actions** - Quick fixes and refactoring suggestions
- **Symbol search** - Find symbols across your workspace (Ctrl+T)

**Font**: MesloLGM Nerd Font is configured as the default terminal font. Install it on Windows for the best Oh My Posh experience.

To disable format-on-save, add to workspace settings:
```json
"[nim]": {
  "editor.formatOnSave": false
}
```

### Changing Port Mappings

Edit `docker-compose.yml` and add/modify port mappings:

```yaml
ports:
  - "8080:8080"
  - "5000:5000"  # Add your custom port
```

## 🔄 Updating the Environment

### Updating Nim Version

To update to a different Nim version:

1. Enter the container
2. Use grabnim to install a new version:
   ```bash
   grabnim --install <version> --dest /opt/nim
   ```

Or modify the `Dockerfile` to install a specific version and rebuild.

### Rebuilding the Container

After making changes to `Dockerfile` or `docker-compose.yml`:

```powershell
# Stop and remove the container
docker-compose down

# Rebuild and start
docker-compose up -d --build
```

If using Dev Containers in VS Code:
- Press `F1`
- Select: `Dev Containers: Rebuild Container`

## 📦 Managing Dependencies

### Docker Dependencies

All Docker dependencies are specified in:
- **Dockerfile**: System packages, compilers, and build tools
- **docker-compose.yml**: Container configuration, volumes, networks

### Nim Dependencies

Nim dependencies are typically managed per-project using `.nimble` files:

```nim
# myproject.nimble
requires "nim >= 2.0.0"
requires "asynctools >= 0.1.0"
requires "chronicles >= 0.10.0"
```

Install project dependencies:
```bash
nimble install -y
```

### Common Nim Packages

Pre-installed packages:
- `asynctools`: Async utilities
- `result`: Result type for error handling
- `unittest2`: Modern unit testing
- `chronicles`: Structured logging

## 🐛 Troubleshooting

### Container Won't Start

```powershell
# Check Docker Desktop is running
# View container logs
docker-compose logs -f

# Remove and rebuild
docker-compose down -v
docker-compose up -d --build
```

### nimlangserver Not Found

```bash
# Inside the container, reinstall
nimble install -y nimlangserver
```

### Permission Issues on Windows

Ensure your Windows user has permissions for the project directory and Docker Desktop is properly configured with WSL2.

### Port Already in Use

Edit `docker-compose.yml` to use different host ports:
```yaml
ports:
  - "8081:8080"  # Changed from 8080:8080
```

## 🎓 Learning Resources

- [Nim Official Documentation](https://nim-lang.org/documentation.html)
- [Nim by Example](https://nim-by-example.github.io/)
- [Nim Forum](https://forum.nim-lang.org/)
- [Awesome Nim](https://github.com/ringabout/awesome-nim)

## 📝 Docker Commands Reference

### Container Management

```powershell
# Start container
docker-compose up -d

# Stop container
docker-compose down

# Restart container
docker-compose restart

# View running containers
docker-compose ps

# View logs
docker-compose logs -f nim-dev

# Execute command in container
docker-compose exec nim-dev bash
```

### Image Management

```powershell
# Build image
docker-compose build

# Rebuild without cache
docker-compose build --no-cache

# List images
docker images

# Remove image
docker rmi nim-dev:latest
```

### Volume Management

```powershell
# List volumes
docker volume ls

# Inspect a volume
docker volume inspect nim-dev-nimble-cache

# Remove all project volumes (careful!)
docker-compose down -v
```

### Cleanup

```powershell
# Remove stopped containers and unused images
docker system prune

# Remove everything including volumes (destructive!)
docker system prune -a --volumes
```

## 🔐 Security Notes

- This container runs as `root` by default (standard for development containers)
- Do not use this setup for production deployments
- Be cautious when mounting sensitive directories from your host machine

## 📄 License

This Docker configuration is provided as-is for development purposes. Nim and all included tools are subject to their respective licenses.

## 🌐 Using This Image Elsewhere

This image is fully portable and can be pulled/used anywhere:

### As a Pre-built Image

If you push this to a registry (Docker Hub, GitHub Container Registry, etc.):

```bash
# On another machine
docker pull yourname/nim-dev:latest
docker run -it -v $(pwd):/workspace yourname/nim-dev:latest
```

### Directory Independence

The container is self-contained:
- ✅ All tools installed in standard locations (`/opt/nim`, `/opt/zig`)
- ✅ Directories created automatically if missing
- ✅ No host dependencies required (except Docker)
- ✅ Works on any system with Docker installed

### Customization on Pull

Users can override installation paths during build:

```bash
git clone https://github.com/yourname/nim-docker-dev.git
cd nim-docker-dev
docker build --build-arg NIMBASE=/custom/path -t nim-dev .
```

### Minimal Run Requirements

To run this container anywhere:
1. Docker or Docker Desktop installed
2. (Optional) Mount workspace: `-v /path/to/project:/workspace`
3. (Optional) Mount SSH keys: `-v ~/.ssh:/root/.ssh:ro`
4. (Optional) Mount Git config: `-v ~/.gitconfig:/root/.gitconfig:ro`

Everything else is self-contained in the image!

## 📦 Publishing to Docker Hub

This entire environment can be published as a single image to Docker Hub for easy distribution.

### Quick Publish

```powershell
# Login to Docker Hub
docker login

# Build and publish using the helper script
.\publish.ps1 -username yourusername -version 1.0.0

# Or manually
docker build -t yourusername/nim-dev:latest .
docker push yourusername/nim-dev:latest
```

### Using Published Image

Once published, anyone can use it:

```bash
# Pull from Docker Hub
docker pull yourusername/nim-dev:latest

# Run with workspace
docker run -it -v $(pwd):/workspace yourusername/nim-dev:latest

# Or update docker-compose.yml to use published image
services:
  nim-dev:
    image: yourusername/nim-dev:latest
    # ... rest of configuration
```

See [PUBLISHING.md](PUBLISHING.md) for detailed publishing instructions, GitHub Actions automation, and version management.

## 🤝 Contributing

Feel free to customize this environment for your needs. To adapt this for another directory:

1. Copy all files to the new directory
2. Update paths in `docker-compose.yml` if needed
3. Modify `Dockerfile` for specific requirements
4. Adjust `.devcontainer/devcontainer.json` for VS Code settings

## 📞 Support

For issues related to:
- **Nim**: Visit the [Nim Forum](https://forum.nim-lang.org/)
- **Docker**: Check [Docker Documentation](https://docs.docker.com/)
- **Dev Containers**: See [VS Code Dev Containers Docs](https://code.visualstudio.com/docs/devcontainers/containers)

---

**Happy Nim Coding! 🎉**

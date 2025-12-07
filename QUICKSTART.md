# Nim Development Environment - Quick Reference

## 🚀 Quick Start (First Time Setup)

1. **Clone and open**:
   ```powershell
   git clone https://github.com/xrfez/NimBase.git
   cd NimBase
   code .
   ```

2. **Reopen in container**:
   - Press `F1`
   - Select: `Dev Containers: Reopen in Container`
   - Wait for build (5-10 minutes)

3. **Done!** Terminal opens at `/projects/NimBase` ready to code.

---

## Container Commands

### Using Management Script (Easiest)
```powershell
# Start container
.\manage.ps1 start

# Enter container
.\manage.ps1 shell

# Stop container
.\manage.ps1 stop

# Rebuild
.\manage.ps1 build

# View status
.\manage.ps1 status

# See all commands
.\manage.ps1 help
```

### Start/Stop Container (Manual)
```powershell
# Start container
docker-compose up -d

# Stop container
docker-compose down

# Restart
docker-compose restart
```

### Enter Container
```powershell
# Using docker-compose (recommended)
docker-compose exec nim-dev zsh

# Using docker directly
docker exec -it nim-dev-container zsh

# Then navigate to your workspace
cd /projects/NimBase
```

**Note**: The container starts in `/root`. Always navigate to `/projects/NimBase` to access your workspace.

## Nim Commands

### Compilation
```bash
# Compile only
nim c myfile.nim

# Compile and run
nim c -r myfile.nim

# Release build (optimized)
nim c -d:release myfile.nim

# Different compiler backends
nim c --cc:gcc myfile.nim      # GCC (default)
nim c --cc:clang myfile.nim    # Clang
nim c --cc:tcc --threads:off myfile.nim  # Tiny C Compiler (requires --threads:off)
```

### Debugging
```bash
# Compile with debug symbols
nim c --debugger:native myfile.nim

# Debug with GDB (GCC binaries)
gdb ./myfile

# Debug with LLDB (LLVM/Clang binaries)
lldb ./myfile
```

### Cross-Compilation
```bash
# Windows executable (from Linux container)
nim c --os:windows --cpu:amd64 -d:mingw myfile.nim

# Windows with Zig
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc --os:windows --cpu:amd64 myfile.nim

# macOS (Intel)
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc --os:macosx --cpu:amd64 myfile.nim

# macOS (ARM - M1/M2)
nim c --cc:clang --clang.exe=zigcc --clang.linkerexe=zigcc --os:macosx --cpu:arm64 myfile.nim

# 32-bit Windows
nim c --os:windows --cpu:i386 -d:mingw myfile.nim
```

### Windows Executable Icons & Version Info
```bash
# Quick: Add icon with rcedit (requires Wine)
nim c --os:windows -d:mingw myapp.nim
wine /usr/local/bin/rcedit.exe myapp.exe --set-icon icon.ico

# Better: Use windres during compilation
x86_64-w64-mingw32-windres app.rc -O coff -o app.res
nim c --os:windows -d:mingw --passL:app.res myapp.nim

# Full version info with rcedit
wine /usr/local/bin/rcedit.exe myapp.exe \
  --set-icon icon.ico \
  --set-version-string "CompanyName" "My Company" \
  --set-version-string "FileDescription" "My App" \
  --set-file-version "1.0.0.0"
```

### Package Management
```bash
# Search for packages
nimble search <query>

# Install package
nimble install <package>

# Install from .nimble file
nimble install -y

# Update packages
nimble refresh
nimble upgrade <package>

# List installed packages
nimble list -i
```

### Project Management
```bash
# Initialize new project (interactive)
nimble init

# Install dependencies from .nimble file (always specify versions!)
nimble install

# Setup project (install deps and compile)
nimble setup
```

### Code Formatting
```bash
# Format a file
nph myfile.nim

# Format all .nim files
find . -name "*.nim" -exec nph {} \;
```

### Testing
```bash
# Run tests
nim c -r tests/test_myfile.nim

# With coverage
nim c -r --nimcache:nimcache --passC:--coverage --passL:--coverage tests/test_myfile.nim
```

## Bun Package Manager

```bash
# Initialize project
bun init

# Install dependencies
bun install
bun add <package>

# Run scripts
bun run script.js

# Execute without installing
bunx <package>
```

## Docker-in-Docker

```bash
# Run services for your project
docker run -d --name postgres -e POSTGRES_PASSWORD=pass -p 5432:5432 postgres
docker run -d --name redis -p 6379:6379 redis

# Use docker compose
docker compose up -d

# Build images
docker build -t myapp .

# List running containers
docker ps

# Stop services
docker stop postgres redis
docker rm postgres redis
```

## Git Operations

```bash
# Git credentials are shared from Windows host
# Your SSH keys and .gitconfig are automatically available

# Clone repositories
git clone git@github.com:user/repo.git
git clone https://github.com/user/repo.git

# Normal Git workflow
git add .
git commit -m "message"
git push

# Test SSH access
ssh -T git@github.com

# Configure credential storage for HTTPS
git config --global credential.helper store
```

## Development Workflow

### VS Code Dev Container (Recommended)
1. `code .` (in NimBase directory)
2. Press `F1`
3. Select: `Dev Containers: Reopen in Container`
4. Start coding! (Terminal opens at `/projects/NimBase`)

### Direct Docker Workflow
1. `docker-compose up -d`
2. `docker-compose exec nim-dev zsh`
3. **Navigate to the project**: `cd /projects/NimBase`
4. Work on your code
5. Exit with `exit`
6. `docker-compose down` when done

**Note**: The container starts in `/root`. Always `cd /projects/NimBase` to access your workspace.

## Troubleshooting

### Rebuild Container
```powershell
docker-compose down
docker-compose up -d --build
```

### Clear Cache
```powershell
# Clear Nim cache
docker-compose exec nim-dev rm -rf /root/.cache/nim

# Clear nimble cache
docker-compose exec nim-dev rm -rf /root/.nimble
```

### Check Logs
```powershell
docker-compose logs -f nim-dev
```

## Useful Nim Resources

- Official Docs: https://nim-lang.org/documentation.html
- Nim by Example: https://nim-by-example.github.io/
- Forum: https://forum.nim-lang.org/
- Package Directory: https://nimble.directory/

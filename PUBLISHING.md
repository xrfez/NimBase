# Publishing to Docker Hub

This guide shows how to build and publish this Nim development environment to Docker Hub.

## Prerequisites

- Docker Hub account (create at https://hub.docker.com)
- Docker Desktop installed and running
- Login to Docker Hub from terminal

## Quick Publish

```powershell
# Login to Docker Hub
docker login

# Build and tag the image
docker build -t yourusername/nim-dev:latest .

# Also tag with version
docker build -t yourusername/nim-dev:1.0.0 .

# Push to Docker Hub
docker push yourusername/nim-dev:latest
docker push yourusername/nim-dev:1.0.0
```

## Using the Published Image

Once published, anyone can use it:

```bash
# Pull the image
docker pull yourusername/nim-dev:latest

# Run directly
docker run -it -v $(pwd):/workspace yourusername/nim-dev:latest

# Or use in docker-compose.yml
services:
  nim-dev:
    image: yourusername/nim-dev:latest
    volumes:
      - .:/workspace
```

## Automated Publishing

### GitHub Actions (Recommended)

Create `.github/workflows/docker-publish.yml`:

```yaml
name: Publish Docker Image

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  push_to_registry:
    name: Push Docker image to Docker Hub
    runs-on: ubuntu-latest
    steps:
      - name: Check out the repo
        uses: actions/checkout@v4
      
      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: yourusername/nim-dev
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

Then add secrets to your GitHub repo:
- `DOCKER_USERNAME` - Your Docker Hub username
- `DOCKER_PASSWORD` - Your Docker Hub access token

### Manual Build Script

Use the included `publish.ps1` script:

```powershell
.\publish.ps1 -username yourusername -version 1.0.0
```

## Image Information

### What's Included

The published image contains:
- Nim compiler (latest stable via grabnim)
- All compilers (GCC, Clang, LLVM, TCC, MinGW, Zig)
- Cross-compilation tools
- Docker CLI
- Git, Node.js, Bun
- Oh My Posh with customizable themes
- nimlangserver, NPH formatter
- All build tools (CMake, Make, LLD)

### What's NOT Included

These require mounting from host:
- Your source code (mount `/workspace`)
- SSH keys (mount `~/.ssh`)
- Git config (mount `~/.gitconfig`)
- Custom zsh config (mount `.zshrc.local`)

### Image Size

Expected size: ~2-3 GB
- Base Debian: ~100 MB
- Compilers and tools: ~1.5 GB
- Nim + dependencies: ~500 MB
- Docker CLI: ~50 MB

## Usage Examples

### Simple Usage

```bash
docker run -it yourusername/nim-dev
```

### With Workspace

```bash
docker run -it -v $(pwd):/workspace yourusername/nim-dev
```

### Full Setup with Git

```bash
docker run -it \
  -v $(pwd):/workspace \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  yourusername/nim-dev
```

### With Custom Zsh Config

```bash
docker run -it \
  -v $(pwd):/workspace \
  -v ./my-zshrc.local:/root/.zshrc.local:ro \
  yourusername/nim-dev
```

## Docker Hub Description Template

Use this for your Docker Hub repository description:

```markdown
# Nim Development Environment

Complete Docker-based development environment for the Nim programming language.

## Features
- Nim Compiler (latest stable via grabnim)
- Cross-compilation (Windows, Linux, macOS)
- Multiple C/C++ compilers (GCC, Clang, LLVM, TCC, MinGW, Zig)
- Docker-in-Docker support
- Git with SSH support
- Oh My Posh pre-configured
- VS Code Dev Containers ready

## Quick Start

docker run -it -v $(pwd):/workspace yourusername/nim-dev

## Documentation
Full documentation: https://github.com/yourusername/nim-docker-dev

## Tags
- `latest` - Latest stable build
- `1.0.0`, `1.1.0`, etc. - Specific versions
```

## Version Management

Recommended tagging strategy:

- `latest` - Always points to newest stable version
- `vX.Y.Z` - Specific version tags (e.g., `v1.0.0`)
- `vX.Y` - Minor version tags (e.g., `v1.0`)
- `vX` - Major version tags (e.g., `v1`)

Example:
```bash
docker build -t yourusername/nim-dev:latest .
docker build -t yourusername/nim-dev:1.0.0 .
docker build -t yourusername/nim-dev:1.0 .
docker build -t yourusername/nim-dev:1 .

docker push yourusername/nim-dev:latest
docker push yourusername/nim-dev:1.0.0
docker push yourusername/nim-dev:1.0
docker push yourusername/nim-dev:1
```

## Maintenance

### Updating the Image

When you update the Dockerfile:

1. Update version in tags
2. Build locally and test
3. Push new version
4. Update `latest` tag

```powershell
docker build -t yourusername/nim-dev:1.1.0 .
docker tag yourusername/nim-dev:1.1.0 yourusername/nim-dev:latest
docker push yourusername/nim-dev:1.1.0
docker push yourusername/nim-dev:latest
```

### Keeping Dependencies Updated

Regular updates:
- Nim version (grabnim updates)
- Zig version (update VERSION in Dockerfile)
- System packages (rebuild periodically)
- Base image updates (Debian Bookworm)

## License

MIT License - See LICENSE file for details

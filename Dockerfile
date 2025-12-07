# Dockerfile for Nim Programming Language Development Environment
# This creates a complete development environment for Nim using:
# - grabnim for Nim installation and version management
# - nimlangserver for LSP support
# - NPH for code formatting
# - Multiple compilers (GCC, Clang, LLVM, Zig, MinGW)
# - Cross-compilation support for Windows, Linux, macOS
# - Node.js and Bun for JavaScript tooling

# Base image: Debian Bookworm (stable, lightweight)
FROM debian:bookworm-slim

# Build arguments for customizable installation paths
# Can be overridden during build: docker build --build-arg NIMBASE=/custom/path
ARG NIMBASE=/opt/nim
ARG ZIGPATH=/opt/zig

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    # Nim installation paths (using build args)
    NIMBASE=${NIMBASE} \
    # Zig installation path (using build args)
    ZIGPATH=${ZIGPATH} \
    # Set PATH to include Nim, Zig, and other binaries
    PATH=${NIMBASE}/bin:${ZIGPATH}:/root/.nimble/bin:$PATH

# Install system dependencies and compilers
# - build-essential: GCC and essential build tools (make, g++, etc.)
# - clang, llvm: Alternative compilers for Nim
# - llvm-dev: LLVM development libraries and headers
# - lld: LLVM linker (faster than GNU ld)
# - lldb: LLVM debugger
# - libc++-dev, libc++abi-dev: LLVM C++ standard library
# - mingw-w64: MinGW compiler for Windows cross-compilation
# - tcc: Tiny C Compiler (fast, lightweight alternative)
# - cmake: Modern build system generator
# - git: Required for grabnim and package management
# - curl, wget: Download tools
# - ca-certificates: SSL support
# - libssl-dev: OpenSSL development files
# - nodejs, npm: JavaScript runtime and package manager
# - xz-utils: Required for extracting Zig archive
# - gnupg, lsb-release: Required for Docker repository setup
# - ripgrep, fd-find: Modern search tools
# - bat: Cat with syntax highlighting
# - fzf: Fuzzy finder
# - eza: Modern ls replacement
# - neovim: Modern vim
# - tmux: Terminal multiplexer
# - valgrind, gdb, strace: Debugging tools
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    llvm \
    llvm-dev \
    libclang-dev \
    lld \
    lldb \
    libc++-dev \
    libc++abi-dev \
    mingw-w64 \
    tcc \
    cmake \
    git \
    curl \
    wget \
    ca-certificates \
    libssl-dev \
    nodejs \
    npm \
    xz-utils \
    unzip \
    gnupg \
    lsb-release \
    ripgrep \
    fd-find \
    bat \
    fzf \
    neovim \
    tmux \
    valgrind \
    gdb \
    strace \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for fd and bat (Debian uses different names)
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd && \
    ln -sf /usr/bin/batcat /usr/local/bin/bat

# Install eza (modern ls replacement) from GitHub releases
RUN TEMP_DEB="$(mktemp)" && \
    wget -O "$TEMP_DEB" 'https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz' && \
    tar -xzf "$TEMP_DEB" -C /usr/local/bin && \
    rm -f "$TEMP_DEB"

# Configure tmux with sensible defaults
# - Mouse support for easier window/pane management
# - Better prefix key (Ctrl+a instead of Ctrl+b)
# - Vi-style copy mode keybindings
RUN mkdir -p /root/.config/tmux && \
    { \
    echo '# Tmux Configuration - Minimal Sensible Defaults'; \
    echo ''; \
    echo '# Change prefix from Ctrl+b to Ctrl+a (easier to reach)'; \
    echo 'unbind C-b'; \
    echo 'set-option -g prefix C-a'; \
    echo 'bind-key C-a send-prefix'; \
    echo ''; \
    echo '# Enable mouse support for easier window/pane management'; \
    echo 'set -g mouse on'; \
    echo ''; \
    echo '# Vi-style copy mode'; \
    echo 'setw -g mode-keys vi'; \
    echo 'bind-key -T copy-mode-vi v send-keys -X begin-selection'; \
    echo 'bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel'; \
    echo ''; \
    echo '# Split panes using | and -'; \
    echo 'bind | split-window -h'; \
    echo 'bind - split-window -v'; \
    echo 'unbind '"'"'"'; \
    echo 'unbind %'; \
    echo ''; \
    echo '# Reload config with r'; \
    echo 'bind r source-file ~/.tmux.conf \; display "Config reloaded!"'; \
    echo ''; \
    echo '# Start window numbering at 1'; \
    echo 'set -g base-index 1'; \
    echo 'setw -g pane-base-index 1'; \
    echo ''; \
    echo '# Better colors'; \
    echo 'set -g default-terminal "screen-256color"'; \
    } > /root/.tmux.conf

# Configure Neovim with minimal sensible defaults
# - Line numbers and syntax highlighting
# - LSP support for Nim via nimlangserver
# - Basic quality-of-life improvements
RUN mkdir -p /root/.config/nvim && \
    { \
    echo '-- Neovim Configuration - Minimal Sensible Defaults'; \
    echo ''; \
    echo '-- Basic settings'; \
    echo 'vim.opt.number = true          -- Show line numbers'; \
    echo 'vim.opt.relativenumber = true  -- Relative line numbers'; \
    echo 'vim.opt.mouse = "a"            -- Enable mouse support'; \
    echo 'vim.opt.clipboard = "unnamedplus"  -- Use system clipboard'; \
    echo 'vim.opt.expandtab = true       -- Use spaces instead of tabs'; \
    echo 'vim.opt.tabstop = 2            -- 2 spaces for tab'; \
    echo 'vim.opt.shiftwidth = 2         -- 2 spaces for indentation'; \
    echo 'vim.opt.smartindent = true     -- Smart auto-indenting'; \
    echo 'vim.opt.wrap = false           -- No line wrapping'; \
    echo 'vim.opt.ignorecase = true      -- Ignore case in search'; \
    echo 'vim.opt.smartcase = true       -- Unless uppercase is used'; \
    echo 'vim.opt.termguicolors = true   -- Better colors'; \
    echo 'vim.opt.signcolumn = "yes"     -- Always show sign column'; \
    echo ''; \
    echo '-- Key mappings'; \
    echo 'vim.g.mapleader = " "          -- Space as leader key'; \
    echo ''; \
    echo '-- File explorer (netrw)'; \
    echo 'vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })'; \
    echo ''; \
    echo '-- Better window navigation'; \
    echo 'vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })'; \
    echo 'vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })'; \
    echo 'vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })'; \
    echo 'vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })'; \
    echo ''; \
    echo '-- Save and quit shortcuts'; \
    echo 'vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })'; \
    echo 'vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })'; \
    echo ''; \
    echo '-- Clear search highlighting'; \
    echo 'vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })'; \
    echo ''; \
    echo '-- LSP configuration for Nim (uses nimlangserver)'; \
    echo 'vim.api.nvim_create_autocmd("FileType", {'; \
    echo '  pattern = "nim",'; \
    echo '  callback = function()'; \
    echo '    -- Key mappings for LSP'; \
    echo '    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, desc = "Go to definition" })'; \
    echo '    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "Show hover info" })'; \
    echo '    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = true, desc = "Rename symbol" })'; \
    echo '    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = true, desc = "Code actions" })'; \
    echo '  end,'; \
    echo '})'; \
    } > /root/.config/nvim/init.lua

# Install Docker CLI for Docker-in-Docker support
# This allows running docker commands inside the container
# The Docker daemon runs on the host, only the CLI is in the container
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install Zig compiler (for zigcc cross-compilation)
# Zig provides excellent cross-compilation capabilities
# Download latest stable Zig release
# Creates directory automatically if it doesn't exist
RUN ARCH="x86_64" && \
    ZIG_VERSION="0.13.0" && \
    mkdir -p ${ZIGPATH} && \
    curl -fSL "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-${ARCH}-${ZIG_VERSION}.tar.xz" -o /tmp/zig.tar.xz && \
    tar -xf /tmp/zig.tar.xz -C /tmp && \
    mv /tmp/zig-linux-${ARCH}-${ZIG_VERSION}/* ${ZIGPATH}/ && \
    rm -rf /tmp/zig* && \
    chmod +x ${ZIGPATH}/zig

# Install Bun (modern JavaScript runtime with built-in package manager)
# Bun is installed globally and available in PATH
# Bun includes: bunx (package runner), bun install, bun run
RUN curl -fsSL https://bun.sh/install | bash \
    && ln -s /root/.bun/bin/bun /usr/local/bin/bun \
    && ln -s /root/.bun/bin/bunx /usr/local/bin/bunx

# Create Nim installation directory
# Uses mkdir -p so it works even if directory exists or parent doesn't exist
RUN mkdir -p ${NIMBASE}

# Install grabnim (Nim version manager by janAkali) from releases
# Using pre-built binary from releases
# Source: https://codeberg.org/janAkali/grabnim
RUN GRABNIM_VERSION="v0.4.0" \
    && curl -fsSL "https://codeberg.org/janAkali/grabnim/releases/download/${GRABNIM_VERSION}/grabnim_linux_gnu_amd64.tar.xz" -o /tmp/grabnim.tar.xz \
    && tar -xf /tmp/grabnim.tar.xz -C /tmp \
    && mv /tmp/grabnim /usr/local/bin/grabnim \
    && chmod +x /usr/local/bin/grabnim \
    && rm -f /tmp/grabnim.tar.xz

# Install latest stable Nim version using grabnim
# grabnim without arguments installs latest stable version
# grabnim installs to ~/.local/share/grabnim/ by default
RUN grabnim fetch \
    && grabnim \
    && echo "Checking Nim installation..." \
    && ls -la ~/.local/share/grabnim/ || true \
    && INSTALLED_NIM=$(find ~/.local/share/grabnim -maxdepth 1 -type d -name "nim-*" | head -n 1) \
    && echo "Found Nim at: $INSTALLED_NIM" \
    && if [ -n "$INSTALLED_NIM" ]; then \
    cp -r "$INSTALLED_NIM"/* ${NIMBASE}/ && \
    chmod +x ${NIMBASE}/bin/* 2>/dev/null || true && \
    echo "Nim installed to ${NIMBASE}"; \
    else \
    echo "ERROR: Could not find Nim installation" && exit 1; \
    fi

# Ensure nimble is available
# grabnim should set this up, but verify it's working
RUN if [ ! -f "${NIMBASE}/bin/nimble" ]; then \
    echo "Warning: nimble not found, installing manually..." && \
    cd /tmp && \
    git clone https://github.com/nim-lang/nimble.git && \
    cd nimble && \
    ${NIMBASE}/bin/nim c -d:release src/nimble.nim && \
    mv src/nimble ${NIMBASE}/bin/ && \
    cd / && \
    rm -rf /tmp/nimble; \
    fi

# Update nimble package list
RUN nimble refresh

# Install nimlangserver for LSP support in editors
# This provides autocomplete, go-to-definition, and other IDE features
RUN nimble install -y nimlangserver

# Install NPH (Nim Pretty Hacker) for code formatting
# NPH is the modern formatter for Nim code
RUN git clone https://github.com/arnetheduck/nph.git /tmp/nph \
    && cd /tmp/nph \
    && nimble build -y \
    && if [ -f nph ]; then \
    cp nph /usr/local/bin/ && chmod +x /usr/local/bin/nph; \
    elif [ -f bin/nph ]; then \
    cp bin/nph /usr/local/bin/ && chmod +x /usr/local/bin/nph; \
    else \
    echo "Warning: NPH build succeeded but executable not found, skipping..."; \
    fi \
    && cd / \
    && rm -rf /tmp/nph

# Create symlink from nph to nimpretty for compatibility
# Some tools expect nimpretty, so we link NPH to it (if NPH was installed)
RUN if [ -f /usr/local/bin/nph ]; then \
    ln -sf /usr/local/bin/nph ${NIMBASE}/bin/nimpretty; \
    else \
    echo "NPH not available, nimpretty symlink skipped"; \
    fi

# Install common Nim packages for development
# These are frequently used packages that developers often need
# RUN nimble install -y \
#     asynctools \
#     result \
#     unittest2 \
#     chronicles

# Install Oh My Posh for modern cross-platform prompt theming
# Oh My Posh provides consistent theming across Windows, Linux, and macOS
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Install and configure Oh My Posh with markbull theme
# Create zsh configuration
RUN mkdir -p /root/.config && \
    { \
    echo '# Oh My Posh initialization for Nim development'; \
    echo 'eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/markbull.omp.json)"'; \
    echo ''; \
    echo '# VS Code shell integration for better terminal experience'; \
    echo '[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)" 2>/dev/null || true'; \
    echo ''; \
    echo '# Custom aliases for Nim development'; \
    echo "alias nimr='nim c -r'"; \
    echo "alias nimrel='nim c -d:release'"; \
    echo "alias nimcross='nim c --cpu:amd64 --os:windows --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc'"; \
    echo ''; \
    echo '# Source local customizations if they exist (persists across rebuilds)'; \
    echo '# Persistent zsh configs are stored in /root/.zsh_persistent/'; \
    echo 'if [ -f /root/.zsh_persistent/.zshrc.local ]; then'; \
    echo '    source /root/.zsh_persistent/.zshrc.local'; \
    echo 'fi'; \
    echo ''; \
    echo '# Show Nim development environment info on startup'; \
    echo 'echo "======================================"'; \
    echo 'echo "  Nim Development Environment"'; \
    echo 'echo "  with Oh My Posh (markbull theme)"'; \
    echo 'echo "======================================"'; \
    echo 'echo "Nim:    $(nim --version | head -n1)"'; \
    echo 'echo "Zig:    $(zig version)"'; \
    echo 'echo "Git:    $(git --version)"'; \
    echo 'echo "Docker: $(docker --version)"'; \
    echo 'echo ""'; \
    echo 'echo "Cross-compilation enabled for:"'; \
    echo 'echo "  - Linux (native)"'; \
    echo 'echo "  - Windows (MinGW, Zigcc)"'; \
    echo 'echo "  - macOS (Zigcc)"'; \
    echo 'echo ""'; \
    echo 'echo "Workspace: /projects/NimBase"'; \
    echo 'echo "======================================"'; \
    } > /root/.zshrc_custom

# Create persistent zsh config directory and default .zshrc.local
RUN mkdir -p /root/.zsh_persistent && \
    { \
    echo '# Persistent Zsh Configuration'; \
    echo '# This file is stored in a Docker volume and persists across container rebuilds'; \
    echo '# Add your custom aliases, functions, and environment variables here'; \
    echo ''; \
    echo '# Example customizations:'; \
    echo '# export MY_VAR="value"'; \
    echo '# alias myalias="command"'; \
    } > /root/.zsh_persistent/.zshrc.local

# Create workspace directory (will be overridden by volume mount)
RUN mkdir -p /workspace

# Set working directory (updated by devcontainer to /projects/NimBase)
WORKDIR /projects/NimBase

# Default shell is bash for Linux container
# Zsh will be available when Oh My Zsh is installed via devcontainer feature
SHELL ["/bin/bash", "-c"]

# Set up bash prompt with version information
# This runs when using bash (before zsh is configured)
RUN echo 'export PS1="\[\e[1;32m\][nim-dev]\[\e[0m\] \w $ "' >> /root/.bashrc \
    && echo 'echo "======================================"' >> /root/.bashrc \
    && echo 'echo "  Nim Development Environment"' >> /root/.bashrc \
    && echo 'echo "======================================"' >> /root/.bashrc \
    && echo 'echo "Nim:    $(nim --version | head -n1)"' >> /root/.bashrc \
    && echo 'echo "Zig:    $(zig version)"' >> /root/.bashrc \
    && echo 'echo "Git:    $(git --version)"' >> /root/.bashrc \
    && echo 'echo "GCC:    $(gcc --version | head -n1)"' >> /root/.bashrc \
    && echo 'echo "Clang:  $(clang --version | head -n1)"' >> /root/.bashrc \
    && echo 'echo "TCC:    $(tcc -v 2>&1 | head -n1)"' >> /root/.bashrc \
    && echo 'echo "MinGW:  $(x86_64-w64-mingw32-gcc --version | head -n1)"' >> /root/.bashrc \
    && echo 'echo "CMake:  $(cmake --version | head -n1)"' >> /root/.bashrc \
    && echo 'echo "Docker: $(docker --version)"' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc \
    && echo 'echo "Cross-compilation enabled for:"' >> /root/.bashrc \
    && echo 'echo "  - Linux (native)"' >> /root/.bashrc \
    && echo 'echo "  - Windows (MinGW, Zigcc)"' >> /root/.bashrc \
    && echo 'echo "  - macOS (Zigcc)"' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc \
    && echo 'echo "Workspace: /workspace"' >> /root/.bashrc \
    && echo 'echo "======================================"' >> /root/.bashrc \
    && echo 'echo "Tip: Type '\''zsh'\'' for Oh My Zsh shell"' >> /root/.bashrc

# Expose common ports for development
# 8080: Common development server port
# 3000: Node.js/React development server
EXPOSE 8080 3000

# Default command: start bash shell
CMD ["/bin/bash"]

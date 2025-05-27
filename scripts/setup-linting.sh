#!/bin/bash

# Setup script for linting and development tools
# Installs luacheck and related dependencies for local development

set -e

echo "Setting up linting tools for Turres-Monacorum..."

# Detect package manager and install accordingly
if command -v apt-get &> /dev/null; then
    echo "Installing dependencies via apt-get..."
    sudo apt-get update
    sudo apt-get install -y luarocks love lua5.1 liblua5.1-dev
elif command -v pacman &> /dev/null; then
    echo "Installing dependencies via pacman..."
    sudo pacman -S --needed luarocks love lua51
elif command -v brew &> /dev/null; then
    echo "Installing dependencies via homebrew..."
    brew install luarocks love lua@5.1
elif command -v dnf &> /dev/null; then
    echo "Installing dependencies via dnf..."
    sudo dnf install luarocks love lua lua-devel
else
    echo "Unsupported package manager. Please install luarocks and love manually."
    exit 1
fi

# Install Lua packages
echo "Installing Lua packages..."
sudo luarocks install luacheck
sudo luarocks install busted

# Verify installation
echo "Verifying installation..."
if command -v luacheck &> /dev/null; then
    echo "✓ luacheck installed successfully"
    luacheck --version
else
    echo "✗ luacheck installation failed"
    exit 1
fi

if command -v busted &> /dev/null; then
    echo "✓ busted installed successfully"
    busted --version
else
    echo "✗ busted installation failed"
    exit 1
fi

echo ""
echo "Setup complete! You can now run:"
echo "  luacheck love2d/          # Run linting"
echo "  busted                    # Run tests"
echo ""
echo "To run linting on the entire codebase:"
echo "  luacheck love2d/"
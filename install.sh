#!/bin/bash
set -e

INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="pokedex-greeting"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing pokedex-greeting..."
echo

# Check for python3
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is required but not found."
    exit 1
fi

# Check for pokemon-colorscripts
if ! command -v pokemon-colorscripts &> /dev/null; then
    echo "Error: pokemon-colorscripts is required but not found."
    echo
    echo "Install it first:"
    echo "  Arch (AUR): yay -S pokemon-colorscripts-git"
    echo "  Manual:     https://gitlab.com/phoneybadger/pokemon-colorscripts"
    exit 1
fi

# Create install directory if needed
mkdir -p "${INSTALL_DIR}"

# Copy script
cp "${SCRIPT_DIR}/${SCRIPT_NAME}" "${INSTALL_DIR}/${SCRIPT_NAME}"
chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"

echo "Installed to ${INSTALL_DIR}/${SCRIPT_NAME}"
echo

# Check if install dir is on PATH
if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
    echo "Warning: ${INSTALL_DIR} is not on your PATH."
    echo "Add this to your shell config:"
    echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
    echo
fi

# Build cache
echo "Building Pokedex cache (fetches type data from PokeAPI, ~2 minutes on first run)..."
echo
"${INSTALL_DIR}/${SCRIPT_NAME}" --build-cache
echo

# Print shell config instructions
echo "Done! To show a Pokedex entry on every terminal open, add this to your shell config:"
echo
echo "  # bash (~/.bashrc) or zsh (~/.zshrc):"
echo "  pokedex-greeting"
echo
echo "  # fish (~/.config/fish/config.fish):"
echo "  pokedex-greeting"
echo

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

# Detect shell config files
SHELL_CONFIGS=()
[[ -f "${HOME}/.bashrc" ]] && SHELL_CONFIGS+=("${HOME}/.bashrc")
[[ -f "${HOME}/.zshrc" ]] && SHELL_CONFIGS+=("${HOME}/.zshrc")
[[ -f "${HOME}/.config/fish/config.fish" ]] && SHELL_CONFIGS+=("${HOME}/.config/fish/config.fish")

# Offer to add to each detected shell config
ADDED=false
for config in "${SHELL_CONFIGS[@]}"; do
    if grep -q "pokedex-greeting" "${config}" 2>/dev/null; then
        echo "Already present in ${config}, skipping."
        ADDED=true
        continue
    fi

    read -rp "Add pokedex-greeting to ${config}? [y/N] " answer
    if [[ "${answer}" =~ ^[Yy]$ ]]; then
        echo "" >> "${config}"
        echo "# Show a random Pokedex entry on terminal open" >> "${config}"
        echo "pokedex-greeting" >> "${config}"
        echo "Added to ${config}"
        ADDED=true
    fi
done

if [[ "${ADDED}" == false ]]; then
    echo "To show a Pokedex entry on every terminal open, add this to your shell config:"
    echo "  pokedex-greeting"
fi

echo
echo "Stealth mode: output is automatically suppressed during screensharing (PipeWire)."
echo "Use 'pokedex-greeting --no-stealth' to disable this."
echo
echo "To update after a git pull, just re-run: bash install.sh"

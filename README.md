# pokedex-greeting

A random Pokedex entry greeting for your terminal. Shows a pokemon sprite with its dex number, name, and color-coded type(s) every time you open a new terminal.

![pokedex-greeting showing Kirlia](screenshot.png)

## How it works

On each invocation, the script picks a random pokemon from all 905 available and displays:

- A unicode sprite (via `pokemon-colorscripts`)
- The national Pokedex number
- The pokemon's name
- Its type(s), color-coded to match the games

Type data is fetched once from PokeAPI and cached locally (`~/.cache/pokedex-greeting/pokedex.json`), so subsequent runs are instant (~150ms).

## Prerequisites

- **Python 3.6+**
- **[pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts)** -- provides the unicode pokemon sprites

### Installing pokemon-colorscripts

**Arch Linux (AUR):**

```bash
yay -S pokemon-colorscripts-git
```

**Other distros:** See the [pokemon-colorscripts repo](https://gitlab.com/phoneybadger/pokemon-colorscripts) for manual installation instructions.

## Install

### Quick install

```bash
git clone https://github.com/WSeubring/pokedex-greeting.git
cd pokedex-greeting
bash install.sh
```

The install script will:

1. Copy `pokedex-greeting` to `~/.local/bin/`
2. Build the Pokedex cache (fetches type data from PokeAPI, takes ~2 minutes on first run)
3. Print instructions for adding it to your shell config

### Manual install

```bash
# Copy the script to somewhere on your PATH
cp pokedex-greeting ~/.local/bin/
chmod +x ~/.local/bin/pokedex-greeting

# Build the cache (one-time, requires internet)
pokedex-greeting --build-cache

# Add to your shell config (~/.bashrc, ~/.zshrc, etc.)
echo 'pokedex-greeting' >> ~/.bashrc
```

## Usage

```bash
pokedex-greeting              # Show a random Pokedex entry
pokedex-greeting --build-cache  # Rebuild the type/dex cache
```

## Acknowledgements

- [pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts) by phoneybadger -- for the unicode pokemon sprites
- [PokeAPI](https://pokeapi.co/) -- for pokemon type and dex number data

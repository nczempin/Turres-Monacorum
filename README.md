# Turres Monacorum

[![CI](https://github.com/nczempin/Turres-Monacorum/actions/workflows/ci.yml/badge.svg?branch=work)](https://github.com/nczempin/Turres-Monacorum/actions/workflows/ci.yml)

Turres Monacorum is a tower defense game built with [Löve2D](https://love2d.org/). It challenges you to defend a medieval monastery from waves of invaders by placing and upgrading towers. The project began as a hobby collaboration and is maintained as an open source game.

Visit the project page at <http://nczempin.github.io/Turres-Monacorum/>.

## Prerequisites

- Löve2D 0.9.1 or newer
- [7‑Zip](https://www.7-zip.org/) to package a Windows build
- For development: LuaRocks with `luacheck` and `busted` for linting and tests

## Build and Test

A GitHub Actions workflow runs lint and test jobs on every push. 

### Development Setup

To set up linting and testing tools locally:

```bash
./scripts/setup-linting.sh
```

Then run the same checks locally:

```bash
luacheck love2d/    # Run linting
busted              # Run tests
```

To create a Windows distributable, execute `buildlöve.bat` from the repository root. The script packs `love2d` together with prebuilt binaries found in `buildmaterial/lovewin64`.

## Status

The game is playable but still under active development. Contributions are welcome!

* For source distribution, just pick your favourite branch from https://github.com/nczempin/Turres-Monacorum and either clone the project via your favourite Git client [we like SourceTree] or just download the provided .zip or .tar.gz source snapshots.

## Setup
Run `./setup.sh` (or `setup.bat` on Windows) to install dependencies before building.
## Development

Use the provided `Makefile` for common tasks:

```
make        # build, test and package the game
make build  # create build/game.love from src/lua
make test   # run tests (none by default)
make package  # create build/tm.zip using the Love2D runtime if present
make clean  # remove build artifacts
```

Turres Monacorum

http://nczempin.github.io/Turres-Monacorum/

Tested with Löve2d 0.9.1.

* Full 64-bit Windows Binary (including dependencies):
On Windows (64 bit), unzip the zip file and start the "turres-monacorum-[...].exe".

* Binary that requires Löve2d to be installed (get it from http://love2d.org/ for Windows, Mac or Linux):
On Windows, drag the file "turres-monacorum-[...].love" onto the love.exe or a shortcut of the exe.
On Linux and on MacOS, use the .love file as described in your löve documentation.

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


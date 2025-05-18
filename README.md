Turres Monacorum

http://nczempin.github.io/Turres-Monacorum/

Tested with Löve2d 0.9.1.

* Full 64-bit Windows Binary (including dependencies):
On Windows (64 bit), unzip the zip file and start the "turres-monacorum-[...].exe".

* Binary that requires Löve2d to be installed (get it from http://love2d.org/ for Windows, Mac or Linux):
On Windows, drag the file "turres-monacorum-[...].love" onto the love.exe or a shortcut of the exe.
On Linux and on MacOS, use the .love file as described in your löve documentation.

* For source distribution, just pick your favourite branch from https://github.com/nczempin/Turres-Monacorum and either clone the project via your favourite Git client [we like SourceTree] or just download the provided .zip or .tar.gz source snapshots.

* To create your own distributable archive on Windows, run the `buildlöve.bat` script found in the repository root. The batch file packages the contents of the `love2d` directory together with the prebuilt Löve2D binaries from `buildmaterial\lovewin64`. It requires [7‑Zip](https://www.7-zip.org/); edit the path to `7z.exe` at the top of the script if necessary. Running the script produces a `tm.zip` file in the project root containing `tm.exe` and all needed DLLs. Temporary files are written to `buildtmp/`, which is listed in `.gitignore`.

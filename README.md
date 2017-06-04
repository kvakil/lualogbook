# logbook

A logbook using LuaLaTeX.

## Installation

1. Install Lua 5.1 and luarocks. 
2. Install MoonScript using `luarocks`.
3. Install LuaLaTeX.
4. Install latexmk.
5. Install biber.
6. Install pandoc.
7. Install Python and pip.
8. Install panflute using `pip`.
9. Install git (optional: can remove from Makefile).

## Daily Usage

1. Use `make today` to add a template in `YYYY/MM/DD.md` and open in Sublime Text.
2. Modify the above file.
3. Use `make` to create `log.pdf`.
4. `git commit` when done.

### Other Files

1. Use `citations/citations.bib` for citations.
2. New includes should go on in `document_setup.sty`.
2. New commands should go on in `command_library.sty`.
4. Modify `log.tex` yearly: add `includer.include_year("YYYY")`.
5. Use `make clean` to clean everything up.

## Likely Problems

1. `pandoc` may require packages not present in `document_setup.sty`. If this happens, use `--standalone` and add the necessary lines under the `pandoc` header.
2. `latexmk` being annoying: use `latexmk -g`

# Technologies Used

1. `MoonScript`: language which transpiles to Lua, except better.
2. `pandoc` & `panflute`: handle the markdown to LaTeX conversion while ensuring the formatting and labels don't break.
3. `Makefile` and `latexmk`: a rather precarious combination. All LaTeX compilation is handled by `latexmk`, and all `pandoc` things are handled by `make`.
4. `git`: for version control.
5. `LuaLaTeX`: the real engine, which runs the Lua files and compiles. 

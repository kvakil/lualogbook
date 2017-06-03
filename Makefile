####################################
# See 2017/06/02 for documentation #
####################################


# latex options
MAIN=log
LATEXMKOPTS=-pdflatex=lualatex -pdf
LATEXMK=latexmk $(LATEXMKOPTS)

# moonscript
MOONFILES=$(wildcard *.moon)
LUAFILES=$(MOONFILES:.moon=.lua)
MOONFLAGS=

# ease of use
TODAY=$(shell date +%Y/%m/%d).tex

all: $(MAIN).pdf $(MOONFILES)

today:
	cp --no-clobber _template.inc $(TODAY)
	git add $(TODAY)
	subl $(TODAY)

%.lua: %.moon
	moonc $(MOONFLAGS) $<

$(MAIN).pdf: $(MOONFILES) .PHONY
	$(LATEXMK)

force: $(MOONFILES) .PHONY
	$(LATEXMK) -g

.PHONY:

clean:
	rm *.lua || true
	latexmk -C

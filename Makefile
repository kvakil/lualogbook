####################################
# See 2017/06/02 for documentation #
####################################


# latex options
MAIN=log
LATEXMKOPTS=-pdflatex=lualatex -pdf
LATEXMK=latexmk $(LATEXMKOPTS)

# moonscript
MOON_IN=$(wildcard *.moon)
MOON_OUT=$(MOON_IN:.moon=.lua)
MOONFLAGS=

# pandoc
MD_IN=$(wildcard */*/*.md)
MD_OUT=$(MD_IN:.md=.tex)
PANDOCFLAGS= -F filter.py -f markdown -t latex

# ease of use
TODAY=$(shell date +%Y/%m/%d).md

all: $(MAIN).pdf

$(MAIN).pdf: $(MOON_OUT) $(MD_OUT) .PHONY
	$(LATEXMK)

view: $(MAIN).pdf
	xreader $(MAIN).pdf

today:
	cp --no-clobber _template.inc $(TODAY)
	git add $(TODAY)
	subl $(TODAY)

%.lua: %.moon
	moonc $(MOONFLAGS) $<

%.tex: %.md
	pandoc $(PANDOCFLAGS) -M title:$< -o $@ $<

clean:
	rm *.lua || true
	latexmk -C
	git clean -ndX

.PHONY:

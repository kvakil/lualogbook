# latex options
define LATEXMKOPTS
-pdflatex="lualatex -interaction=nonstopmode %S %O" -pdf -dvi- -ps-
endef
LATEXMK=latexmk $(LATEXMKOPTS)

# pandoc
MD_IN=$(wildcard */*/*.md)
MD_OUT=$(MD_IN:.md=.tex)
PANDOCFLAGS= -F pandoc_filter.py -f markdown -t latex

# ease of use
TODAY=$(shell date +%Y/%m/%d).md

all: log.pdf

log.pdf: $(MD_OUT)
	$(LATEXMK)

force: $(MD_OUT)
	rm log.pdf
	$(LATEXMK)

view: log.pdf
	xreader log.pdf

today:
	touch $(TODAY)
	git add $(TODAY)
	subl $(TODAY)

%.tex: %.md
	pandoc $(PANDOCFLAGS) -M title:$< -o $@ $<

ldoc:
	ldoc lua/

clean:
	latexmk -C
	git clean -idX

.PHONY: log.pdf force

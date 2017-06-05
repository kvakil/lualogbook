# latex options
MAIN=log
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

all: $(MAIN).pdf

$(MAIN).pdf: $(MD_OUT) .PHONY
	$(LATEXMK)

view: $(MAIN).pdf
	xreader $(MAIN).pdf

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

.PHONY:

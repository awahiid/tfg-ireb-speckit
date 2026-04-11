TEX=apuntes-cpre
OUT=.generated

.PHONY: all pdf clean distclean

all: pdf

pdf:
	mkdir -p $(OUT)
	pdflatex -interaction=nonstopmode -output-directory=$(OUT) $(TEX).tex
	cd $(OUT) && BIBINPUTS=.:.. bibtex $(TEX)
	pdflatex -interaction=nonstopmode -output-directory=$(OUT) $(TEX).tex
	pdflatex -interaction=nonstopmode -output-directory=$(OUT) $(TEX).tex

clean:
	rm -f $(OUT)/$(TEX).aux $(OUT)/$(TEX).bbl $(OUT)/$(TEX).blg $(OUT)/$(TEX).fdb_latexmk $(OUT)/$(TEX).fls $(OUT)/$(TEX).log $(OUT)/$(TEX).out $(OUT)/$(TEX).toc $(OUT)/$(TEX).synctex.gz

distclean: clean
	rm -f $(OUT)/$(TEX).pdf

include ~/tex/common.mak
SHOW=no
LATEX=xelatex
BIBTEX=bibtex

all: cv.pdf

%.pdf: %.tex
	$(LATEX) $<
	if ! egrep -s '\\documentclass\[(.*,)*\s*draft\s*(,.*)*\]{' $< ; then \
		$(BIBTEX) $(patsubst %.tex,%.aux,$<) || true ; \
		$(LATEX) $< ; \
		latex_count=5 ; \
		while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(patsubst %.tex,%.log,$<) && [ $$latex_count -gt 0 ] ;\
		do \
			echo "Rerunning latex...." ;\
			$(LATEX) $< ; \
			latex_count=`expr $$latex_count - 1` ;\
		done; \
	fi
	if [ "$(SHOW)" == "yes" ]; then $(PDFVIEWER) $@; fi

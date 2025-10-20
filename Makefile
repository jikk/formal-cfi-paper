LATEX=pdflatex
BIBER=biber -f --output-safechars
BIBTEX=bibtex
BIBCMD=$(BIBER)
RM=rm -f

##############################
TARGET=main
PNAME=formalcfi
##############################

TEXFILES=*.tex sections/*.tex tables/*.tex
BIBFILES=refs/*.bib
FIGURES=figs/*.pdf figs/*.png figs/*.jpg

.PHONY: dvi ps pdf figures word main all clean test

all: $(TARGET).pdf
	cp $(TARGET).pdf $(PNAME).pdf

$(TARGET).pdf: $(TEXFILES)
	$(LATEX) $(TARGET)
	$(BIBCMD) $(TARGET)
	$(LATEX) $(TARGET)
	# latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf $(TARGET)

word: pandoc

pandoc:
	pandoc word.tex -o $(TARGET).docx

clean:
	$(RM) $(addprefix $(TARGET)., aux bbl blg log dvi toc lof out ps pdf fls sysnctex.gz fdb_latexmk bcf run.xml)
	$(RM) $(PNAME).pdf

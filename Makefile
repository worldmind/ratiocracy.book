NAME = ratiocracy
HTML_DIR = ../ratiocracy.github.io/book/
FILE_DIR = ../ratiocracy.github.io/book/download/
XSL_DIR = xsl/
LOG_FILE = make.log

all: validate clean autoformat prepare latex pdfs html htmlonepage odt plaintext epub3
book: validate clean prepare latex pdfa5

autoformat:
	black scripts

clean:
	echo 'MAKE clean' | tee -a $(LOG_FILE)
	git clean -d -f -X >> $(LOG_FILE) 2>&1

ecover:
	convert cover/front_cover.ru.png ~/ecover.ru.jpg

latex:
	python3 scripts/docbook2latex.py

prepare:
	echo 'MAKE dirs' | tee -a $(LOG_FILE)
	mkdir -p $(FILE_DIR)
	mkdir -p $(FILE_DIR)/html
	mkdir -p $(HTML_DIR)

prepdf: clean prepare latex

glossa4: prepdf
	echo 'MAKE glossary a4' | tee -a $(LOG_FILE)
	pdflatex $(NAME)-a4 >> $(LOG_FILE) 2>&1
	makeglossaries $(NAME)-a4 >> $(LOG_FILE) 2>&1
	echo 'Done' | tee -a $(LOG_FILE)

glossa5: prepdf
	echo 'MAKE glossary a5' | tee -a $(LOG_FILE)
	pdflatex $(NAME)-a5 >> $(LOG_FILE) 2>&1
	makeglossaries $(NAME)-a5 >> $(LOG_FILE) 2>&1
	echo 'Done' | tee -a $(LOG_FILE)

glossa6: prepdf
	echo 'MAKE glossary a6' | tee -a $(LOG_FILE)
	pdflatex $(NAME)-a6 >> $(LOG_FILE) 2>&1
	makeglossaries $(NAME)-a6 >> $(LOG_FILE) 2>&1
	echo 'Done' | tee -a $(LOG_FILE)

pdfs: pdfa4 pdfa5 pdfa6

pdfa4: glossa4
	echo 'CREATE pdf' | tee -a $(LOG_FILE)
	rubber --pdf $(NAME)-a4 >> $(LOG_FILE) 2>&1
	mv -f $(NAME)-a4.pdf $(FILE_DIR)
	echo 'Done' | tee -a $(LOG_FILE)

pdfa5: glossa5
	echo 'CREATE pdf A5' | tee -a $(LOG_FILE)
	rubber --pdf $(NAME)-a5 >> $(LOG_FILE) 2>&1
	cp -f $(NAME)-a5.pdf $(FILE_DIR)
	echo 'Done' | tee -a $(LOG_FILE)

a5: pdfa5

pdfa6: glossa6
	echo 'CREATE pdf A6' | tee -a $(LOG_FILE)
	rubber --pdf $(NAME)-a6 >> $(LOG_FILE) 2>&1
	mv -f $(NAME)-a6.pdf $(FILE_DIR)
	echo 'Done' | tee -a $(LOG_FILE)

pdf-for-printing: glossa5
	echo 'CREATE pdf A5 for printing' | tee -a $(LOG_FILE)
	rubber --pdf $(NAME)-a5-ingramspark >> $(LOG_FILE) 2>&1
	mv -f $(NAME)-a5-ingramspark.pdf ~/978-952-94-7393-9_txt.pdf
	echo 'Done pdf for printing' | tee -a $(LOG_FILE)

p: pdf-for-printing

validate:
	xmlstarlet val --err --xsd /usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd $(NAME).docbook

#fb2:  # Need to update something for not download old saxon processor
#	echo 'CREATE fb2' | tee -a $(LOG_FILE)
# https://sourceforge.net/projects/saxon/
#	java -jar ~/.saxon/saxon9he.jar -o:$(FILE_DIR)/$(NAME).fb2 $(NAME).docbook $(XSL_DIR)/docbook2fb2.xsl
#	xmllint --format --noblanks $(FILE_DIR)/$(NAME).fb2 > $(NAME).fb2
#	mv $(NAME).fb2 $(FILE_DIR)/$(NAME).fb2
# FIXME not valid for now
#	xmlstarlet val --err --xsd ../fb2/FictionBook.xsd $(FILE_DIR)/$(NAME).fb2

html:
	echo 'CREATE chunked HTML' | tee -a $(LOG_FILE)
	xsltproc --xinclude $(XSL_DIR)/html-params.xsl $(NAME).docbook >> $(LOG_FILE) 2>&1

htmlonepage:
	echo 'CREATE one page HTML' | tee -a $(LOG_FILE)
	xsltproc --xinclude $(XSL_DIR)/html-onepage-params.xsl $(NAME).docbook > $(FILE_DIR)/html/$(NAME).html

plaintext: htmlonepage
	echo 'CREATE plain text' | tee -a $(LOG_FILE)
	html2text $(FILE_DIR)/html/$(NAME).html > $(FILE_DIR)/$(NAME).txt

epub3:
	echo 'CREATE epub3' | tee -a $(LOG_FILE)
	mkdir -p epub
	xsltproc --xinclude $(XSL_DIR)/epub3-params.xsl $(NAME).docbook >> $(LOG_FILE) 2>&1
	python3 scripts/fix_epub.py
	cd epub; zip -0Xq ../$(FILE_DIR)/$(NAME).epub mimetype >> ../$(LOG_FILE) 2>&1
	cd epub; zip -Xr9D ../$(FILE_DIR)/$(NAME).epub META-INF OEBPS >> ../$(LOG_FILE) 2>&1
	epubcheck $(FILE_DIR)/$(NAME).epub 

odt: htmlonepage
	echo 'CREATE odt' | tee -a $(LOG_FILE)
	libreoffice --headless --convert-to odt $(FILE_DIR)/html/$(NAME).html >> $(LOG_FILE) 2>&1
	mv $(NAME).odt $(FILE_DIR)

links_check:
	linkchecker --ignore-url=^mailto: https://ratiocracy.sbs/
	linkchecker --ignore-url=^mailto: -r2 https://ratiocracy.sbs/book/bi01.html

deps:
	wajig install texlive-full calibre html2text rubber linkchecker docbook5-xml docbook-xsl-ns xsltproc libxml2-utils xmlstarlet epubcheck default-jre black

.SILENT:

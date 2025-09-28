.PHONY: all clean html html-plain html-stackoverflow html-canonical docx stackoverflow docx-from-template \
docx-from-html docx-from-html-via-pandoc docx-from-html-via-libre-office

FILENAME_STUB=Joe-Flack-Résumé

all: html docx stackoverflow

clean:
	rm -f output/*

# HTML
output/$(FILENAME_STUB)-plain.html:
	pandoc --defaults defaults/html-plain.yaml > $@

html-plain: output/$(FILENAME_STUB)-plain.html

output/$(FILENAME_STUB)-StackOverflow.html:
	pandoc --defaults defaults/html-stackoverflow.yaml > $@

html-stackoverflow: output/$(FILENAME_STUB)-StackOverflow.html

output/$(FILENAME_STUB).html: output/$(FILENAME_STUB)-StackOverflow.html
	@cp $< $@

html-canonical: output/$(FILENAME_STUB).html

# todo: temp: mv: file in _archive until ready
html: html-plain html-stackoverflow html-canonical
	@mv output/$(FILENAME_STUB)-plain.html output/_archive/html/development_versions/plain/

# DOCX
output/$(FILENAME_STUB).docx:
	pandoc --defaults defaults/docx.yaml > $@

docx-from-template: output/$(FILENAME_STUB).docx

docx-from-html-via-pandoc:
	pandoc output/$(FILENAME_STUB).html -o output/$(FILENAME_STUB)-from-html-via-pandoc.docx

# FYI: "MS Word 2007 XML" is just the filter name LibreOffice uses internally for .docx output. It’s not literally limited to 2007-era features — it produces normal modern Office Open XML DOCX files that open fine in Word 2016/2019/365.
docx-from-html-via-libre-office:
	soffice --headless --convert-to docx:"MS Word 2007 XML" \
	output/$(FILENAME_STUB).html --outdir tmp/
	@mv tmp/$(FILENAME_STUB).docx output/$(FILENAME_STUB)-from-html-via-libre-office.docx

docx-from-html: docx-from-html-via-pandoc docx-from-html-via-libre-office

# todo: temp: mv: file in _archive until ready
docx: docx-from-template docx-from-html
	@mv output/$(FILENAME_STUB).docx output/_archive/docx/development_versions/


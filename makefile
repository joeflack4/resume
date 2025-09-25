.PHONY: all html docx

FILENAME_STUB=Joe-Flack-Resume

all: html docx

clean:
	rm output/*

output/$(FILENAME_STUB).html:
	pandoc --defaults defaults/html.yaml > $@

html: output/$(FILENAME_STUB).html

output/$(FILENAME_STUB).docx:
	pandoc --defaults defaults/docx.yaml > $@

docx: output/$(FILENAME_STUB).docx

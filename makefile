.PHONY: all html docx clean dirs

FILENAME_STUB=Joe-Flack-Resume

all: dirs html docx

dirs:
	mkdir -p output

clean:
	rm -f output/*

output/$(FILENAME_STUB).html:
	pandoc --defaults defaults/html.yaml > $@

html: output/$(FILENAME_STUB).html

output/$(FILENAME_STUB).docx:
	pandoc --defaults defaults/docx.yaml > $@

docx: output/$(FILENAME_STUB).docx

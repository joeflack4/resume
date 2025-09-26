.PHONY: all html html-plain html-stackoverflow html-canonical docx stackoverflow clean dirs

# todo: change to this. for some reason when I have this with the accents, it generates 2 sets of docs, 1 with the accents and 1 without
# todo: probably has to do with some configured "output_file" in some yaml somewhere
#FILENAME_STUB=Joe-Flack-Resume
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

# todo: temp: file in _archive until ready
html: html-plain html-stackoverflow html-canonical
	@mv output/$(FILENAME_STUB)-plain.html output/_archive/html/development_versions/plain/

# DOCX
output/$(FILENAME_STUB).docx:
	pandoc --defaults defaults/docx.yaml > $@

# todo: temp: file in _archive until ready
docx: output/$(FILENAME_STUB).docx
	@mv output/$(FILENAME_STUB).docx output/_archive/docx/development_versions/

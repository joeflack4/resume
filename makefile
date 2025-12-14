.PHONY: all clean html html-plain html-stackoverflow html-canonical docx stackoverflow docx-from-template \
docx-from-html docx-from-html-via-pandoc docx-from-html-via-libre-office default all-unstable \
default--top-n-projects-statements html-canonical--top-n-projects-statements \
html-stackoverflow--oriented-as-statements--top-n-projects-statements

FILENAME_STUB=Joe-Flack-Résumé
N?=5

all-unstable: html docx

all: default

default:
	$(MAKE) html-canonical -B



# todo: move these things around to correct places in file:
default--oriented-as-statements:
	$(MAKE) html-canonical--oriented-as-statements -B

html-canonical--oriented-as-statements: output/$(FILENAME_STUB)--oriented-as-statements.html

output/$(FILENAME_STUB)--oriented-as-statements.html: output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements.html
	@cp $< $@



clean:
	rm -f output/*

# HTML
output/$(FILENAME_STUB)-plain.html:
	pandoc --defaults defaults/html-plain.yaml > $@

html-plain: output/$(FILENAME_STUB)-plain.html

output/$(FILENAME_STUB)-StackOverflow.html:
	pandoc --defaults defaults/html-stackoverflow.yaml > $@

output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M toggles.show_project_statements=true \
		-M toggles.show_project_skills=false > $@

output/$(FILENAME_STUB)-StackOverflow--oriented-as-skills.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M toggles.show_project_statements=false \
		-M toggles.show_project_skills=true > $@

html-stackoverflow: output/$(FILENAME_STUB)-StackOverflow.html

html-stackoverflow--oriented-as-statements: output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements.html

html-stackoverflow--oriented-as-skills: output/$(FILENAME_STUB)-StackOverflow--oriented-as-skills.html

output/$(FILENAME_STUB).html: output/$(FILENAME_STUB)-StackOverflow.html
	@cp $< $@

html-canonical: output/$(FILENAME_STUB).html

# Parameterized versions with top-n-projects-statements
output/$(FILENAME_STUB)-StackOverflow--top-n-$(N)-projects-statements.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M toggles.top-n-projects-to-include-statements-blocks=$(N) > $@

output/$(FILENAME_STUB)--top-n-$(N)-projects-statements.html: output/$(FILENAME_STUB)-StackOverflow--top-n-$(N)-projects-statements.html
	@cp $< $@

html-canonical--top-n-projects-statements: output/$(FILENAME_STUB)--top-n-$(N)-projects-statements.html

default--top-n-projects-statements:
	$(MAKE) html-canonical--top-n-projects-statements -B

output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements--top-n-$(N)-projects-statements.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M toggles.show_project_statements=true \
		-M toggles.show_project_skills=false \
		-M toggles.top-n-projects-to-include-statements-blocks=$(N) > $@

html-stackoverflow--oriented-as-statements--top-n-projects-statements: output/$(FILENAME_STUB)-StackOverflow--oriented-as-statements--top-n-$(N)-projects-statements.html

# todo: temp: mv: file in _archive until ready
html: html-plain html-stackoverflow html-canonical
	@mv output/$(FILENAME_STUB)-plain.html output/_archive/html/development_versions/plain/

# DOCX
output/$(FILENAME_STUB).docx:
	pandoc --defaults defaults/docx.yaml > $@

docx-from-template: output/$(FILENAME_STUB).docx

# input: canonical
output/$(FILENAME_STUB)-from-html-via-pandoc.docx: output/$(FILENAME_STUB).html
	pandoc $< -o $@

docx-from-html-via-pandoc: output/$(FILENAME_STUB)-from-html-via-pandoc.docx

# FYI: "MS Word 2007 XML" is just the filter name LibreOffice uses internally for .docx output. It’s not literally limited to 2007-era features — it produces normal modern Office Open XML DOCX files that open fine in Word 2016/2019/365.
# input: canonical
output/$(FILENAME_STUB)-from-html-via-libre-office.docx: output/$(FILENAME_STUB).html
	soffice --headless --convert-to docx:"MS Word 2007 XML" \
	$< --outdir tmp/
	@mv tmp/$(FILENAME_STUB).docx $@

docx-from-html-via-libre-office: output/$(FILENAME_STUB)-from-html-via-libre-office.docx

docx-from-html: docx-from-html-via-pandoc docx-from-html-via-libre-office

# todo: temp: mv: file in _archive until ready
docx: docx-from-template docx-from-html
	@mv output/$(FILENAME_STUB).docx output/_archive/docx/development_versions/


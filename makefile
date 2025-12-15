.PHONY: all clean html html-plain html-stackoverflow html-canonical docx stackoverflow docx-from-template \
docx-from-html docx-from-html-via-pandoc docx-from-html-via-libre-office default all-unstable \
default--top-n-projects-statements html-canonical--top-n-projects-statements \
html-stackoverflow--statements-only--top-n-projects-statements html-stackoverflow--top-5-project-details-only \
html-canonical--top-5-project-details-only test

FILENAME_STUB=Joe-Flack-Résumé
N?=5

all-unstable: html docx

all: default

# todo: remove the statements only one
default:
	$(MAKE) html-canonical -B
	$(MAKE) html-stackoverflow--skills-only -B
	$(MAKE) html-stackoverflow--statements-only -B
	$(MAKE) html-stackoverflow--top-5-project-details-only -B



# todo: move these things around to correct places in file:
default--statements-only:
	$(MAKE) html-canonical--statements-only -B

html-canonical--statements-only: output/$(FILENAME_STUB)--statements-only.html

output/$(FILENAME_STUB)--statements-only.html: output/$(FILENAME_STUB)-StackOverflow--statements-only.html
	@mv $< $@
#	@cp $< $@



clean:
	rm -f output/*

# HTML
output/$(FILENAME_STUB)-plain.html:
	pandoc --defaults defaults/html-plain.yaml > $@

html-plain: output/$(FILENAME_STUB)-plain.html

output/$(FILENAME_STUB)-StackOverflow.html:
	pandoc --defaults defaults/html-stackoverflow.yaml > $@

output/$(FILENAME_STUB)-StackOverflow--statements-only.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M override_show_project_statements=true \
		-M override_show_project_skills=false > $@

output/$(FILENAME_STUB)-StackOverflow--skills-only.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M override_show_project_statements=false \
		-M override_show_project_skills=true > $@

output/$(FILENAME_STUB)--skills-only.html: output/$(FILENAME_STUB)-StackOverflow--skills-only.html
	@mv $< $@
#	@cp $< $@

output/$(FILENAME_STUB)-StackOverflow--top-5-project-details-only.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M override_top_n_projects=5 > $@

output/$(FILENAME_STUB)--top-5-project-details-only.html: output/$(FILENAME_STUB)-StackOverflow--top-5-project-details-only.html
	@mv $< $@
#	@cp $< $@

html-stackoverflow: output/$(FILENAME_STUB)-StackOverflow.html

html-stackoverflow--statements-only: output/$(FILENAME_STUB)-StackOverflow--statements-only.html

html-stackoverflow--skills-only: output/$(FILENAME_STUB)--skills-only.html

html-stackoverflow--top-5-project-details-only: output/$(FILENAME_STUB)--top-5-project-details-only.html

html-canonical--top-5-project-details-only: output/$(FILENAME_STUB)--top-5-project-details-only.html

output/$(FILENAME_STUB).html: output/$(FILENAME_STUB)-StackOverflow.html
	@mv $< $@
#	@cp $< $@

html-canonical: output/$(FILENAME_STUB).html

# Parameterized versions with top-n-projects-statements
output/$(FILENAME_STUB)-StackOverflow--top-n-$(N)-projects-statements.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M override_top_n_projects=$(N) > $@

output/$(FILENAME_STUB)--top-n-$(N)-projects-statements.html: output/$(FILENAME_STUB)-StackOverflow--top-n-$(N)-projects-statements.html
	@mv $< $@
#	@cp $< $@

html-canonical--top-n-projects-statements: output/$(FILENAME_STUB)--top-n-$(N)-projects-statements.html

default--top-n-projects-statements:
	$(MAKE) html-canonical--top-n-projects-statements -B

output/$(FILENAME_STUB)-StackOverflow--statements-only--top-n-$(N)-projects-statements.html:
	pandoc --defaults defaults/html-stackoverflow.yaml \
		-M override_show_project_statements=true \
		-M override_show_project_skills=false \
		-M override_top_n_projects=$(N) > $@

html-stackoverflow--statements-only--top-n-projects-statements: output/$(FILENAME_STUB)-StackOverflow--statements-only--top-n-$(N)-projects-statements.html

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


# Testing
test:
	@echo "Running output variant tests..."
	@python tests/run_tests.py

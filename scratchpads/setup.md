
# Setup Checklist

## Programmatic Todos

- [ ] **Makefile Enhancement:**
    - [x] Create a "build all" or "all" target to generate all output formats.
    - [ ] Use variables for source files and output directories to make the Makefile more maintainable.
- [ ] **Templating:**
    - [ ] Develop the `templates/html/base.html5` template with placeholders for metadata and content.
    - [ ] Style the HTML output with CSS in `templates/html/style.css`.
    - [ ] Add print-specific styles in `templates/html/print.css`.
    - [ ] Configure `templates/docx/reference.docx` with desired Word styles (headings, body text, etc.).
- [ ] **Data Integration:**
    - [ ] Write a script or enhance the Makefile to merge `data/meta.yml` and a variant from `data/variants/` into a single YAML file to be used by pandoc.
    - [ ] Ensure pandoc can correctly consume the merged YAML data.

## Content Writing Todos @dev
@dev: These are only for the user / dev. Not for the agent to do.

- [ ] **`data/meta.yml`:**
    - [ ] Fill in your name, contact information (email, phone), and links (LinkedIn, GitHub, portfolio).
    - [ ] Define any tags or categories for skills and experiences.
    - [ ] Set up any toggles for including/excluding sections.
- [ ] **`data/variants/*.yml`:**
    - [ ] For each resume variant (e.g., `general.yml`, `data-eng.yml`), define the specific content to be used. This could be a list of experience files to include, or specific skills to highlight.
- [ ] **`content/01-header.md`:**
    - [ ] Write your name and contact information here, using pandoc template variables (e.g., `$name$`).
- [ ] **`content/02-summary.md`:**
    - [ ] Write a professional summary or objective.
- [ ] **`content/10-experience/*.md`:**
    - [ ] For each job or project, create a new markdown file.
    - [ ] Detail your responsibilities and accomplishments for each role.
- [ ] **`content/20-skills.md`:**
    - [ ] List your technical and soft skills.
- [ ] **`content/30-education.md`:**
    - [ ] List your degrees, certifications, and any other relevant education.

# Setup
1. `brew install pandoc`

# Usage

This repository uses Pandoc to generate multiple resume formats from Markdown and YAML source files.

## Generating Documents

To generate all resume formats, run:

```bash
make all
```

This will create `output/resume.html` and `output/resume.docx`.

To generate a specific format, use:

```bash
make html
```

or

```bash
make docx
```

## How it Works

- **`content/`**: This directory contains the main content of your resume in Markdown files.
- **`data/`**: This directory holds your personal information (`meta.yml`) and different resume variations (`variants/`).
- **`templates/`**: This directory contains the HTML and DOCX templates to style your resume.
- **`defaults/`**: This directory contains the default pandoc configurations for each output format.
- **`makefile`**: The makefile contains the commands to build the resume formats.
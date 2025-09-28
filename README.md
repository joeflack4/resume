# Personal résumeé and associated builder

## Set up
- Install pandoc (MacOS, can do: `brew install pandoc`)

## Quick start
- `make all -B`: Output all templates

## Common workflows
### Update reésumé content
Edit content in `content/` and profile data in `data/meta.yml`.

### Converting to output
- `make all -B`: Output all templates
- See: Makefile for commands for specific HTML, DOCX representations, etc.

## Understanding the Pandoc pipeline
### Canonical directories
```
.
├── content/     # Markdown sections: Markdown sections that feed the resume body
├── data/        # Vars: YAML metadata and variant toggles referenced by pandoc
├── defaults/    # Builds: Pandoc default files defining inputs and outputs
├── templates/   # Templates: HTML/DOCX/etc templates and styles applied during builds
└── output/      # Output: Generated artifacts (html, docx) from the make targets
```

### Template flow
Example of HTML template, showing some inputs and how they work together to generate output.

#### 1. The content files
`content/02-summary.md`:
```md
## Summary
MY SUMMARY
```

`content/30-education.md`:
```
## Education
- **SCHOOL 1**: INFO
- **SCHOOL 2**: INFO
```

#### 2. TOC (Table of Contents)
`defaults/html-plain.yaml`
```yaml
input-files:
  - content/02-summary.md
  - content/30-education.md
```

#### 2. Template  
```html
$body$
```

#### Output
```html
<h2 id="summary">Summary</h2>
  <p><MY SUMMARY/p>

<h2 id="education">Education</h2>
<ul>
  <li><strong>SCHOOL 1</strong>: INFO</li>
  <li><strong>SCHOOL 2</strong>: INFO</li>
</ul>
```

## Misc
Some folders are ignored by the system and have special usage.

E.g. `content-alt/` has alternate versions of some files found in `content/`.

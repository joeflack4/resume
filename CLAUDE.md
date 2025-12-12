# Agent guide
This repo is all about a pipeline and tooling to create and customize a specific individual's résumé.


This system generates resumes using **YAML → Pandoc → HTML/PDF** pipelines. Your job as an agent is to modify YAML data,
HTML templates, and CSS styles without breaking the structure or rendering flow.

## 🔧 Core Components

### 1. YAML Data Files
These hold all structured resume information.

Examples:
- `meta.yml` — name, contact info, website, social links, as well as some configs, e.g. to toggles  
- `work-experience.yml` — jobs, summaries, job-level skills, nested projects  
- `projects.yml` — standalone projects  
- `education.yml`, `skills.yml`, etc.

Each YAML file is consumed by Pandoc templates via variables such as:

```
$meta.name$
$for(work-experience)$
  $work-experience.title$
$endfor$
```

### 2. Template configurations
These define metadata, pathing, and more configuration.
- e.g. `defaults/html-stackoverflow.yaml`

### 3. Pandoc Templates
Pandoc uses templates to convert YAML into e.g. HTML or DOCX.

Key template files:
- `templates/html-stackoverflow/stackoverflow-theme.html`
- `templates/docx/custom-reference.docx`

The templates define:
- Page layout  
- Section structure  
- Rendering loops (`$for(...)$`)  
- Conditional blocks (`$if(...)$`)  
- Inline content like skills, summaries, roles, and URLs  

### 4. Extra dirs to ignore
Please ignore these dirs. They are referenced in the code, but have no effect on the outputs, given how things are 
setup. This is basically an alterantive approach to template interpolation based on what we are doing now, using the 
`data/` files. 
- `content/`
- `content-alt/`

## ⚙️ How Everything Fits Together
1. **Write / Edit YAML** — canonical source of content  
2. **Run Pandoc** — interpolates variables into templates  
3. **CSS applies UI styling**  
4. **Output as HTML / PDF / DOCX**

## Usage
Pipelines are set up in the `makefile`. There are commands for running templates by output format, canonical vs 
specialized, and running the full pipeline (`make all`).

## 📌 Agent Responsibilities
### ✅ Do
- Preserve Pandoc syntax  
- Keep YAML valid  
- Maintain consistency between YAML, templates, and CSS  

### ❌ Don’t
- Break Pandoc parsing  
- Rename variables without updating all references  
- Add JS or incompatible markup

## 📚 Glossary
**Pandoc variables** — template tokens replaced by YAML  
**Interpolation** — inserting YAML values into templates  
**Conditional blocks** — `$if(...)$`  
**Loops** — `$for(...)$ ... $endfor$`  
**Skill block** — inline grouped skills
**Statement block** — inline grouped statements

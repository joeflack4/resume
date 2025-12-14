# H2 Header Spacing Analysis

## Problem Description
The h2 headers (particularly "Education" and "Projects") in `output/Joe-Flack-Résumé.html` (doc1) have excessive spacing after them compared to the template `templates/in-development/html-stackoverflow/_archive/v/1-downloaded-b4-customization/stack1.html` (doc2).

## Root Cause Analysis

### Structural Difference
**Doc1 (Current - INCORRECT):**
```html
<section class="section"><header><h2 class="section-title">Education</h2></header></section>
<section id="education">
```

**Doc2 (Template - CORRECT):**
```html
<section class="section">
    <header><h2 class="section-title">Education</h2></header>
    <section id="education">
```

### The Problem
In doc1, the `<section class="section">` wrapper is being closed immediately after the header, creating two separate section elements instead of one properly nested structure. This breaks the CSS cascade and spacing relationships.

### CSS Context
From the template's CSS, the spacing is controlled by:
- `.section { margin-bottom: 1rem; }`
- `.section > header { position: relative; }`
- `.section > header::after` (creates decorative line)

The broken structure in doc1 means the content section is not properly nested within the main section wrapper, causing:
1. Extra margin from the orphaned section wrapper
2. Missing CSS relationships between header and content
3. Broken visual hierarchy

## Proposed Solutions

### Solution 1: Fix Nesting Structure (RECOMMENDED)
Correct the HTML structure to match the template:
```html
<section class="section">
    <header><h2 class="section-title">Education</h2></header>
    <section id="education">
        <!-- content here -->
    </section>
</section>
```

### Solution 2: CSS Override (NOT RECOMMENDED)
Add CSS to compensate for the broken structure, but this is a bandaid solution:
```css
.section + section {
    margin-top: -1rem;
}
```

### Solution 3: Template Validation
Ensure the Pandoc template that generates the HTML produces the correct nested structure.

## Files to Fix
1. `output/Joe-Flack-Résumé.html` - Lines around 3930-3932 (Education section)
2. `output/Joe-Flack-Résumé.html` - Lines around 3921 (Projects section)

## Implementation Priority
**HIGH** - This affects visual consistency and breaks the intended design system of the template.
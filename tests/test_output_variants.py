"""
Tests to verify that different output variants are generated correctly.

This test suite verifies that the makefile targets produce distinct outputs
with the correct inclusion/exclusion of skills and statements blocks.
"""

import re
from pathlib import Path


# Path to output directory
OUTPUT_DIR = Path(__file__).parent.parent / "output"


def count_pattern_in_file(filepath: Path, pattern: str) -> int:
    """Count occurrences of a pattern in a file."""
    if not filepath.exists():
        raise FileNotFoundError(f"File not found: {filepath}")

    content = filepath.read_text()
    return len(re.findall(pattern, content))


def test_output_files_exist():
    """Verify that all expected output files exist."""
    expected_files = [
        "Joe-Flack-Résumé.html",
        "Joe-Flack-Résumé--skills-only.html",
        "Joe-Flack-Résumé-StackOverflow--statements-only.html",
        "Joe-Flack-Résumé--top-5-project-details-only.html",
    ]

    for filename in expected_files:
        filepath = OUTPUT_DIR / filename
        assert filepath.exists(), f"Expected output file not found: {filename}"


def test_canonical_has_both_skills_and_statements():
    """Verify that the canonical output has both skills and statements."""
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé.html"

    # Count skills blocks (the actual <p> tags, not CSS or comments)
    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    # Count statements blocks
    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    assert skills_count > 0, "Canonical should have skills blocks"
    assert statements_count > 0, "Canonical should have statements blocks"

    print(f"✓ Canonical has {skills_count} skills and {statements_count} statements")


def test_skills_only_has_no_statements():
    """Verify that skills-only variant has skills but no statements."""
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--skills-only.html"

    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    assert skills_count > 0, "Skills-only should have skills blocks"
    assert statements_count == 0, "Skills-only should NOT have statements blocks"

    print(f"✓ Skills-only has {skills_count} skills and {statements_count} statements")


def test_statements_only_has_no_skills():
    """Verify that statements-only variant has statements but no skills."""
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé-StackOverflow--statements-only.html"

    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    assert skills_count == 0, "Statements-only should NOT have skills blocks"
    assert statements_count > 0, "Statements-only should have statements blocks"

    print(f"✓ Statements-only has {skills_count} skills and {statements_count} statements")


def test_outputs_are_different():
    """Verify that the three output files are actually different."""
    canonical = OUTPUT_DIR / "Joe-Flack-Résumé.html"
    skills_only = OUTPUT_DIR / "Joe-Flack-Résumé--skills-only.html"
    statements_only = OUTPUT_DIR / "Joe-Flack-Résumé-StackOverflow--statements-only.html"

    canonical_content = canonical.read_text()
    skills_only_content = skills_only.read_text()
    statements_only_content = statements_only.read_text()

    assert canonical_content != skills_only_content, \
        "Canonical and skills-only should be different"
    assert canonical_content != statements_only_content, \
        "Canonical and statements-only should be different"
    assert skills_only_content != statements_only_content, \
        "Skills-only and statements-only should be different"

    print("✓ All three output files are distinct")


def test_top_n_minus_one_shows_all():
    """Verify that N=-1 shows all statement blocks (special 'show all' value)."""
    # Default is -1, so canonical should have all 14 statements
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé.html"

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    # We expect all 14 statements when -1 is set
    expected_count = 14
    assert statements_count == expected_count, \
        f"Expected {expected_count} statements with N=-1, found {statements_count}"

    print(f"✓ Shows all {statements_count} statements (N=-1 means 'show all')")


def test_top_n_filtering_works():
    """Verify that setting a specific N value filters statements correctly."""
    # This test requires generating a file with N=3
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--top-n-3-projects-statements.html"

    if not filepath.exists():
        pytest.skip("Test file not generated (run 'make default--top-n-projects-statements N=3' first)")

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    # With N=3, we should only have 3 project statements
    expected_count = 3
    assert statements_count == expected_count, \
        f"Expected {expected_count} statements with N=3, found {statements_count}"

    print(f"✓ Shows {statements_count} statements (N=3 filters correctly)")


def test_top_5_project_details_only():
    """Verify that top-5-project-details-only variant has exactly 5 statement blocks."""
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--top-5-project-details-only.html"

    assert filepath.exists(), "File should be generated by default command"

    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    # Should have both skills and statements (top 5 only)
    expected_statements = 5
    assert skills_count > 0, "Should have skills"
    assert statements_count == expected_statements, \
        f"Expected exactly {expected_statements} statements, found {statements_count}"

    print(f"✓ Has {skills_count} skills and {statements_count} statements (top 5 projects)")


if __name__ == "__main__":
    # Allow running tests directly
    import pytest
    import sys

    sys.exit(pytest.main([__file__, "-v"]))

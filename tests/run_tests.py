#!/usr/bin/env python3
"""
Standalone test runner that doesn't require pytest.

Run this script to verify that output variants are generated correctly.
"""

import re
import sys
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
    print("\n🔍 Testing: Output files exist...")

    expected_files = [
        "Joe-Flack-Résumé.html",
        "Joe-Flack-Résumé--skills-only.html",
        "Joe-Flack-Résumé-StackOverflow--statements-only.html",
        "Joe-Flack-Résumé--top-5-project-details-only.html",
    ]

    all_exist = True
    for filename in expected_files:
        filepath = OUTPUT_DIR / filename
        if filepath.exists():
            print(f"  ✓ {filename}")
        else:
            print(f"  ✗ {filename} NOT FOUND")
            all_exist = False

    return all_exist


def test_canonical_has_both_skills_and_statements():
    """Verify that the canonical output has both skills and statements."""
    print("\n🔍 Testing: Canonical has both skills and statements...")

    filepath = OUTPUT_DIR / "Joe-Flack-Résumé.html"

    # Count skills blocks
    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    # Count statements blocks
    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    success = skills_count > 0 and statements_count > 0

    if success:
        print(f"  ✓ Has {skills_count} skills and {statements_count} statements")
    else:
        print(f"  ✗ Expected both skills and statements")
        print(f"    Found: {skills_count} skills, {statements_count} statements")

    return success


def test_skills_only_has_no_statements():
    """Verify that skills-only variant has skills but no statements."""
    print("\n🔍 Testing: Skills-only has skills but no statements...")

    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--skills-only.html"

    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    success = skills_count > 0 and statements_count == 0

    if success:
        print(f"  ✓ Has {skills_count} skills and {statements_count} statements (correct)")
    else:
        print(f"  ✗ Expected skills > 0 and statements = 0")
        print(f"    Found: {skills_count} skills, {statements_count} statements")

    return success


def test_statements_only_has_no_skills():
    """Verify that statements-only variant has statements but no skills."""
    print("\n🔍 Testing: Statements-only has statements but no skills...")

    filepath = OUTPUT_DIR / "Joe-Flack-Résumé-StackOverflow--statements-only.html"

    skills_count = count_pattern_in_file(
        filepath,
        r'<p class="skills-line skills-line--mono mono--consolas"'
    )

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    success = skills_count == 0 and statements_count > 0

    if success:
        print(f"  ✓ Has {skills_count} skills and {statements_count} statements (correct)")
    else:
        print(f"  ✗ Expected skills = 0 and statements > 0")
        print(f"    Found: {skills_count} skills, {statements_count} statements")

    return success


def test_outputs_are_different():
    """Verify that the three output files are actually different."""
    print("\n🔍 Testing: All three outputs are different...")

    canonical = OUTPUT_DIR / "Joe-Flack-Résumé.html"
    skills_only = OUTPUT_DIR / "Joe-Flack-Résumé--skills-only.html"
    statements_only = OUTPUT_DIR / "Joe-Flack-Résumé-StackOverflow--statements-only.html"

    canonical_content = canonical.read_text()
    skills_only_content = skills_only.read_text()
    statements_only_content = statements_only.read_text()

    tests = [
        (canonical_content != skills_only_content, "Canonical ≠ Skills-only"),
        (canonical_content != statements_only_content, "Canonical ≠ Statements-only"),
        (skills_only_content != statements_only_content, "Skills-only ≠ Statements-only"),
    ]

    all_different = True
    for passed, description in tests:
        if passed:
            print(f"  ✓ {description}")
        else:
            print(f"  ✗ {description} (files are identical!)")
            all_different = False

    return all_different


def test_top_n_minus_one_shows_all():
    """Verify that N=-1 shows all statement blocks (special 'show all' value)."""
    print("\n🔍 Testing: top-n=-1 shows all statements...")

    # Default is -1, so canonical should have all 14 statements
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé.html"

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    # We expect all 14 statements when -1 is set
    expected_count = 14
    success = statements_count == expected_count

    if success:
        print(f"  ✓ Shows all {statements_count} statements (N=-1 means 'show all')")
    else:
        print(f"  ✗ Expected {expected_count} statements with N=-1")
        print(f"    Found: {statements_count} statements")

    return success


def test_top_n_filtering_works():
    """Verify that setting a specific N value filters statements correctly."""
    print("\n🔍 Testing: top-n filtering with specific value...")

    # This test requires generating a file with N=3
    # We'll check if the file exists first
    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--top-n-3-projects-statements.html"

    if not filepath.exists():
        print("  ⚠ Skipping - test file not generated (run 'make default--top-n-projects-statements N=3' first)")
        return True  # Don't fail the test, just skip it

    statements_count = count_pattern_in_file(
        filepath,
        r'<ul class="statements"'
    )

    # With N=3, we should only have 3 project statements
    # (Note: This assumes each project in the importance list has statements)
    expected_count = 3
    success = statements_count == expected_count

    if success:
        print(f"  ✓ Shows {statements_count} statements (N=3 filters correctly)")
    else:
        print(f"  ⚠ Expected ~{expected_count} statements with N=3")
        print(f"    Found: {statements_count} statements")
        print(f"    (This may be expected if not all top-3 projects have statements)")

    return success


def test_top_5_project_details_only():
    """Verify that top-5-project-details-only variant has exactly 5 statement blocks."""
    print("\n🔍 Testing: top-5-project-details-only has 5 statements...")

    filepath = OUTPUT_DIR / "Joe-Flack-Résumé--top-5-project-details-only.html"

    if not filepath.exists():
        print("  ✗ File not found (should be generated by default command)")
        return False

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
    success = skills_count > 0 and statements_count == expected_statements

    if success:
        print(f"  ✓ Has {skills_count} skills and {statements_count} statements (top 5 projects)")
    else:
        print(f"  ✗ Expected all skills + exactly {expected_statements} statements")
        print(f"    Found: {skills_count} skills, {statements_count} statements")

    return success


def main():
    """Run all tests and report results."""
    print("=" * 70)
    print("Resume Output Variant Tests")
    print("=" * 70)

    tests = [
        test_output_files_exist,
        test_canonical_has_both_skills_and_statements,
        test_skills_only_has_no_statements,
        test_statements_only_has_no_skills,
        test_outputs_are_different,
        test_top_n_minus_one_shows_all,
        test_top_n_filtering_works,
        test_top_5_project_details_only,
    ]

    results = []
    for test in tests:
        try:
            passed = test()
            results.append(passed)
        except Exception as e:
            print(f"\n  ✗ ERROR: {e}")
            results.append(False)

    # Summary
    print("\n" + "=" * 70)
    passed = sum(results)
    total = len(results)

    if all(results):
        print(f"✅ All {total} tests passed!")
        return 0
    else:
        print(f"❌ {passed}/{total} tests passed, {total - passed} failed")
        return 1


if __name__ == "__main__":
    sys.exit(main())

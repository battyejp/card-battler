# Documentation

This directory contains various documentation files for the Card Battler project.

## Available Documents

### Code Quality Audits

#### [SRP Audit Report](SRP_AUDIT_REPORT.md)
Comprehensive Single Responsibility Principle (SRP) audit of the entire codebase.

**Contains:**
- Executive summary of findings
- Detailed analysis of 9 SRP violations
- Code examples and refactoring recommendations
- Documentation of good SRP practices
- Priority-based implementation roadmap

**Last Updated:** 2024

#### [SRP Audit Quick Reference](SRP_AUDIT_QUICK_REFERENCE.md)
Quick reference guide for the SRP audit findings.

**Contains:**
- Summary of top priority violations
- Quick links to specific issues
- Implementation checklist
- Testing strategy
- Examples of good SRP practices

**Last Updated:** 2024

## How to Use These Documents

### For Developers
1. Start with the Quick Reference to understand top priorities
2. Refer to the full Audit Report for detailed recommendations
3. Follow the implementation checklist when refactoring

### For Project Managers
1. Use the Quick Reference to understand effort and impact
2. Prioritize work based on the recommendations
3. Track progress against the documented violations

### For Code Reviewers
1. Reference good SRP practices when reviewing PRs
2. Check that new code doesn't introduce similar violations
3. Ensure refactoring work addresses the documented issues

## Contributing to Documentation

When adding new documentation:
1. Place it in this `docs/` directory
2. Update this README with a description
3. Use clear, descriptive filenames
4. Include a "Last Updated" date
5. Add it to version control

## Document Conventions

- Use Markdown (.md) for all documentation
- Include code examples where relevant
- Provide file and line references for specific issues
- Keep formatting consistent across documents
- Use clear section headings for easy navigation

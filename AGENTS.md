# Rules Manager Plugin

A Claude Code plugin for managing project rules. Browse, install, validate, and remove rules from a curated collection.

## Installation

```bash
# Install from local directory (for development)
claude --plugin-dir /path/to/code-manager

# Or add to a marketplace and install
claude plugin install code-manager@your-marketplace
```

## Usage

Once installed, use the `/code-manager:rules` command:

```bash
# Interactive mode - guided rule management
/code-manager:rules

# List all available rules
/code-manager:rules list

# Add a rule to your project
/code-manager:rules add beads-workflow

# Remove a rule from your project
/code-manager:rules remove edd

# Validate installed rules for conflicts
/code-manager:rules validate

# Show current installation status
/code-manager:rules status
```

## Plugin Structure

```
code-manager/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/
│   └── rules.md              # /rules slash command
├── collection/               # Bundled rule library
│   ├── task-management/
│   │   └── Beads.md
│   └── requirements/
│       ├── EDD.md
│       └── PRD.md
├── schema/
│   └── rule-schema.yaml      # Validation schema
├── catalog.yaml              # Rule index with metadata
└── AGENTS.md                 # This file
```

## Available Rules

| Rule ID | Domain | Description |
|---------|--------|-------------|
| `beads-workflow` | task-management | Multi-session task tracking with dependency graphs |
| `edd` | requirements | Design decisions and implementation guides (HOW to build) |
| `prd-workflow` | requirements | High-level product requirements (WHAT to build) |

### Rule Relationships

- **prd-workflow** and **edd** are complementary:
  - PRD defines WHAT to build (product requirements, constraints)
  - EDD defines HOW to build (design decisions, patterns, NFRs)
- **beads-workflow** complements both for task tracking

### Recommended Sets

1. **Complete Workflow**: Beads + PRD + EDD - full task tracking with requirements and design
2. **Product Development**: Beads + PRD - task management with product requirements
3. **Engineering Focus**: Beads + EDD - task management with design decisions

## Maintainer Guide

### Adding a New Rule

1. **Choose the domain** from `schema/rule-schema.yaml`
2. **Create the file** at `collection/<domain>/<RuleName>.md`
3. **Add frontmatter**:

```yaml
---
id: my-rule-id
version: 1.0.0
name: Human Readable Name
description: Brief description (< 160 chars)
domain: task-management
author: github-username
tags: [relevant, tags]
relationship:
  complements: []
  replaces: []
requires:
  tools: []
activation:
  triggers: []
  contexts: []
---

# Rule Title

Rule content here...
```

4. **Update catalog.yaml** with the new rule entry
5. **Validate** the collection remains consistent

### Validation Requirements

Rules must satisfy:

**Structural:**
- `id` is kebab-case (`^[a-z][a-z0-9-]*$`)
- `version` is semver (`X.Y.Z`)
- `domain` exists in taxonomy
- `description` < 160 characters

**Semantic:**
- No circular replacements (A replaces B, B replaces A)
- No complement-replace conflicts
- Same-domain rules should declare relationship

### Domain Taxonomy

| Domain | Description |
|--------|-------------|
| `task-management` | Work tracking, issues, sprints |
| `requirements` | PRDs, design docs, specifications |
| `code-quality` | Style, patterns, architecture |
| `version-control` | Git workflows, branching |
| `testing` | Test strategy, coverage |
| `documentation` | READMEs, API docs |
| `security` | Auth, secrets, OWASP |
| `deployment` | CI/CD, releases |

## Claude Instructions

When maintaining this plugin:

1. Validate all new rules against `schema/rule-schema.yaml`
2. Update `catalog.yaml` when adding/modifying rules
3. Check compatibility when rules share a domain
4. Ensure frontmatter is complete and accurate
5. Test the `/rules` command after changes

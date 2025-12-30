# Rules Management Plugin

A Claude Code plugin for managing project rules. Browse, install, validate, and remove rules from a curated collection.

## Installation

```bash
# Install from local directory (for development)
claude --plugin-dir /path/to/rules-management

# Or add to a marketplace and install
claude plugin install rules-management@your-marketplace
```

## Usage

Once installed, use the `/rules-management:rules` command:

```bash
# Interactive mode - guided rule management
/rules-management:rules

# List all available rules
/rules-management:rules list

# Add a rule to your project
/rules-management:rules add beads-workflow

# Remove a rule from your project
/rules-management:rules remove design-spec

# Validate installed rules for conflicts
/rules-management:rules validate

# Show current installation status
/rules-management:rules status
```

## Plugin Structure

```
rules-management/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── commands/
│   └── rules.md              # /rules slash command
├── collection/               # Bundled rule library
│   ├── task-management/
│   │   └── Beads.md
│   └── requirements/
│       ├── Design-spec.md
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
| `design-spec` | requirements | Requirements tracking using DESIGN.md |
| `prd-workflow` | requirements | Spec-driven development using docs/PRD.md |

### Rule Relationships

- **beads-workflow** complements both `design-spec` and `prd-workflow`
- **design-spec** and **prd-workflow** are alternatives (choose one)

### Recommended Sets

1. **Beads + Design**: Task management with design specification tracking
2. **Beads + PRD**: Task management with PRD-driven development

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

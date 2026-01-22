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

| Rule ID          | Domain          | Description                                               |
| ---------------- | --------------- | --------------------------------------------------------- |
| `beads-workflow` | task-management | Multi-session task tracking with dependency graphs        |
| `edd`            | requirements    | Design decisions and implementation guides (HOW to build) |
| `prd-workflow`   | requirements    | High-level product requirements (WHAT to build)           |

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

| Domain            | Description                       |
| ----------------- | --------------------------------- |
| `task-management` | Work tracking, issues, sprints    |
| `requirements`    | PRDs, design docs, specifications |
| `code-quality`    | Style, patterns, architecture     |
| `version-control` | Git workflows, branching          |
| `testing`         | Test strategy, coverage           |
| `documentation`   | READMEs, API docs                 |
| `security`        | Auth, secrets, OWASP              |
| `deployment`      | CI/CD, releases                   |

## Claude Instructions

When maintaining this plugin:

1. Validate all new rules against `schema/rule-schema.yaml`
2. Update `catalog.yaml` when adding/modifying rules
3. Check compatibility when rules share a domain
4. Ensure frontmatter is complete and accurate
5. Test the `/rules` command after changes

## Rule Versioning

- whenever a rule is modified increment the version of the rule using semver principals

## Agent Workflow (Long-Lived Branch)

This project uses the `dixson-test` branch for development. Changes are regularly rebased against `main` to stay current.

### Daily Development Workflow

1. **Work on the feature branch**: All development happens on `dixson-test`
2. **Commit changes normally**: Use standard git commit workflow
3. **Push to remote**: `git push origin dixson-test`

### Staying Current with Main

When `main` has new commits, rebase `dixson-test` to incorporate them:

```bash
# 1. Ensure working tree is clean
git status  # Must show "nothing to commit, working tree clean"

# 2. Fetch latest changes
git fetch origin

# 3. Rebase onto main
git rebase origin/main

# 4. If conflicts occur:
#    - Edit conflicting files
#    - git add <resolved-files>
#    - git rebase --continue
#    - Repeat until rebase completes

# 5. Force push with safety check
git push --force-with-lease origin dixson-test

# 6. Verify success
git status  # Should show "up to date with origin/dixson-test"
```

### Session Completion (Landing the Plane)

**When ending a work session**, complete ALL steps below:

1. **Commit all changes**: Ensure no uncommitted work remains
2. **Run quality gates** (if code changed):
   - Validate rules: `/code-manager:rules validate` (if modified)
   - Test plugin installation
3. **Push to remote**:
   ```bash
   git status  # Verify branch state
   git push origin dixson-test
   git status  # MUST show "up to date with origin/dixson-test"
   ```
4. **Document handoff**: Note any in-progress work or next steps

### CRITICAL RULES

- **NEVER rebase with uncommitted changes** - commit or stash first
- **ALWAYS use `--force-with-lease`** instead of `--force` when pushing after rebase
- **Work is NOT complete** until `git push` succeeds and shows "up to date"
- **If rebase fails**: Use `git rebase --abort` to return to safe state
- **Target branch**: `dixson-test` (NOT `main`)

### Emergency Recovery

If a rebase goes wrong:

```bash
# Abort in-progress rebase
git rebase --abort

# Or undo completed rebase
git reflog  # Find commit hash before rebase
git reset --hard <commit-hash>
```

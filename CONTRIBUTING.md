# Contributing to Rules Manager

Thank you for your interest in contributing to the Rules Manager plugin!

## Development Setup

### Prerequisites

- [Claude Code CLI](https://claude.ai/code) installed
- Git

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/dixson3/code-manager.git
   cd code-manager
   ```

2. Test the plugin locally in any project:
   ```bash
   # From your target project directory
   claude --plugin-dir /path/to/code-manager
   ```

3. Verify the plugin loaded:
   ```bash
   /code-manager:rules list
   ```

### Development Workflow

1. Make changes to plugin files
2. Restart Claude Code to pick up changes
3. Test your changes with the `/code-manager:rules` command
4. Validate plugin structure before committing

### Testing in Another Project

```bash
# Option 1: Command-line flag (recommended for development)
claude --plugin-dir /path/to/code-manager

# Option 2: Load multiple plugins
claude --plugin-dir ./code-manager --plugin-dir ./other-plugin

# Option 3: Debug mode (shows plugin loading info)
claude --debug --plugin-dir /path/to/code-manager
```

### Project Structure

```
code-manager/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest (name, version, etc.)
├── commands/
│   └── rules.md              # /code-manager:rules command
├── collection/               # Bundled rule library
│   ├── task-management/
│   │   └── Beads.md
│   └── requirements/
│       ├── EDD.md
│       └── PRD.md
├── schema/
│   └── rule-schema.yaml      # Validation schema for rules
├── catalog.yaml              # Rule index with metadata
├── AGENTS.md                 # Claude instructions
└── TODO.md                   # Work tracking
```

## Adding a New Rule

### 1. Choose the Domain

Select from the [domain taxonomy](#domain-taxonomy) or propose a new one.

### 2. Create the Rule File

Create `collection/<domain>/<RuleName>.md` with YAML frontmatter:

```yaml
---
id: my-rule-id
version: 1.0.0
name: Human Readable Name
description: Brief description (< 160 chars)
domain: task-management
author: your-github-username
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

Your rule content here...
```

### 3. Update the Catalog

Add an entry to `catalog.yaml`:

```yaml
  my-rule-id:
    name: "Human Readable Name"
    description: "Brief description"
    domain: task-management
    file: "MyRule.md"
    path: "collection/task-management/MyRule.md"
    version: "1.0.0"
    author: your-github-username
    tags: [relevant, tags]
    relationship:
      complements: []
      replaces: []
```

### 4. Test Your Rule

```bash
claude --plugin-dir /path/to/code-manager

# Verify it appears in the list
/code-manager:rules list

# Test installation
/code-manager:rules add my-rule-id

# Check it was installed
ls .claude/rules/
```

### 5. Submit a Pull Request

1. Fork the repository
2. Create a feature branch
3. Add your rule and catalog entry
4. Update TODO.md if applicable
5. Submit a PR with a clear description

## Domain Taxonomy

| Domain | Description | Examples |
|--------|-------------|----------|
| `task-management` | Work tracking, prioritization | todos, issues, sprints |
| `requirements` | Specifications, traceability | PRDs, design docs |
| `code-quality` | Style, patterns, architecture | linting, conventions |
| `version-control` | Git workflows, branching | commits, PRs |
| `testing` | Test strategy, coverage | TDD, e2e |
| `documentation` | Documentation standards | READMEs, API docs |
| `security` | Security practices | auth, secrets, OWASP |
| `deployment` | CI/CD, releases | pipelines, versioning |

## Validation Requirements

Rules must satisfy:

### Structural
- `id` is kebab-case (`^[a-z][a-z0-9-]*$`)
- `version` is semver (`X.Y.Z`)
- `domain` exists in taxonomy
- `description` < 160 characters

### Semantic
- No circular replacements (A replaces B, B replaces A)
- No complement-replace conflicts
- Same-domain rules should declare relationship

## Code of Conduct

- Be respectful and constructive
- Focus on the work, not the person
- Welcome newcomers and help them contribute

## Questions?

Open an issue on GitHub or reach out to the maintainers.

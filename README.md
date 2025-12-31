# Rules Manager Plugin

A Claude Code plugin for managing project rules. Browse, install, validate, and remove rules from a curated collection.

## Installation

### From GitHub

```bash
# Add the marketplace
claude plugin marketplace add dixson3/code-manager

# Install the plugin
claude plugin install code-manager@dixson3/code-manager
```

### Local Development

```bash
# Test from any project directory
claude --plugin-dir /path/to/code-manager

# With debug output
claude --debug --plugin-dir /path/to/code-manager
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for full development setup.

## Usage

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

## Available Rules

| Rule ID | Domain | Description |
|---------|--------|-------------|
| `beads-workflow` | task-management | Multi-session task tracking with dependency graphs |
| `edd` | requirements | Design decisions and implementation guides (HOW to build) |
| `prd-workflow` | requirements | High-level product requirements (WHAT to build) |

### Rule Compatibility

- **prd-workflow** and **edd** are complementary - use both together:
  - PRD defines WHAT to build (product requirements, constraints)
  - EDD defines HOW to build (design decisions, patterns, NFRs)
- **beads-workflow** complements both for task tracking

### Recommended Combinations

1. **Complete Workflow** - Beads + PRD + EDD (full requirements and design)
2. **Product Development** - Beads + PRD (task management with product requirements)
3. **Engineering Focus** - Beads + EDD (task management with design decisions)

## How It Works

When you run `/code-manager:rules add <rule-id>`, the plugin:

1. Looks up the rule in the bundled collection
2. Copies it to your project's `.claude/rules/` directory
3. Shows complementary rules you might want to add
4. Warns if you're installing conflicting rules

Rules installed to `.claude/rules/` are automatically loaded by Claude Code.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development setup and testing
- Adding new rules
- Domain taxonomy
- Validation requirements

## License

MIT License - see [LICENSE](LICENSE) for details.

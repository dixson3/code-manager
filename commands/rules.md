---
description: Manage Claude Code rules for the active project - list, add, remove, and validate rules
argument-hint: [list|add|remove|validate|status] [rule-id]
---

# Rules Management Command

You are managing Claude Code rules for the user's active project. The rule collection is bundled with this plugin at `${CLAUDE_PLUGIN_ROOT}/collection/`.

## Available Actions

Based on the user's command arguments ($ARGUMENTS), perform one of these actions:

### `list` - Show Available Rules

Read the catalog at `${CLAUDE_PLUGIN_ROOT}/catalog.yaml` and display:
1. All available rules organized by domain
2. For each rule: id, name, description, and relationship info (complements/replaces)
3. Indicate which rules are already installed in the project's `.claude/rules/` directory

Format as a clear table or list.

### `add <rule-id>` - Install a Rule

1. Look up the rule in `${CLAUDE_PLUGIN_ROOT}/catalog.yaml`
2. If not found, show available rule IDs
3. Check if already installed in `.claude/rules/`
4. Read the rule file from `${CLAUDE_PLUGIN_ROOT}/collection/<domain>/<RuleName>.md`
5. Create `.claude/rules/` if it doesn't exist
6. Copy the rule file to `.claude/rules/<RuleName>.md`
7. Report success and show:
   - Complementary rules that work well with this one
   - Any rules this replaces (warn if those are installed)

### `remove <rule-id>` - Uninstall a Rule

1. Find the rule file in `.claude/rules/` matching the rule-id
2. If not found, show what rules are installed
3. Delete the rule file
4. Report success

### `validate` - Check Rule Compatibility

1. Read all rules in `.claude/rules/`
2. Parse their frontmatter for relationship declarations
3. Check for conflicts:
   - Rule A replaces Rule B, but both installed → ERROR
   - Rule A complements Rule B, but B missing → WARNING
4. Report validation results

### `status` - Show Current State

1. List all rules installed in `.claude/rules/`
2. For each, show: name, domain, version
3. Run validation and show any issues
4. Show which bundled rules are NOT installed

## Interactive Mode (no arguments)

If $ARGUMENTS is empty, enter interactive mode:

1. Show current status (installed rules)
2. Use the AskUserQuestion tool to ask what they want to do:
   - "Add a rule" → then ask which rule to add (show available options)
   - "Remove a rule" → then ask which to remove (show installed options)
   - "Validate rules" → run validation
   - "List all available" → show full catalog

## Rule Collection Structure

Rules are organized by domain in `${CLAUDE_PLUGIN_ROOT}/collection/`:
```
collection/
├── task-management/
│   └── Beads.md
└── requirements/
    ├── Design-spec.md
    └── PRD.md
```

## Frontmatter Schema

Each rule has YAML frontmatter with these fields:
- `id`: Unique identifier (e.g., "beads-workflow")
- `name`: Human-readable name
- `description`: Brief description
- `domain`: Category (task-management, requirements, etc.)
- `relationship.complements`: Rules that work alongside
- `relationship.replaces`: Rules this is an alternative to
- `requires.tools`: External tools needed

## Example Interactions

User: `/rules-management:rules`
→ Enter interactive mode, ask what they want to do

User: `/rules-management:rules list`
→ Show all available rules with install status

User: `/rules-management:rules add beads-workflow`
→ Install the beads-workflow rule to .claude/rules/

User: `/rules-management:rules remove design-spec`
→ Remove design-spec from .claude/rules/

User: `/rules-management:rules validate`
→ Check installed rules for conflicts

User: `/rules-management:rules status`
→ Show what's installed and validation state

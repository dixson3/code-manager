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

### `validate` - Check Rule Frontmatter and Compatibility

This command performs two types of validation:

#### A. Frontmatter Schema Validation

1. Read the schema from `${CLAUDE_PLUGIN_ROOT}/schema/rule-schema.yaml`
2. For each rule in the collection (`${CLAUDE_PLUGIN_ROOT}/collection/**/*.md`), parse the YAML frontmatter
3. Check each rule against schema requirements:
   - **Required fields present**: id, version, domain, name, description
   - **ID format**: Must match `^[a-z][a-z0-9-]*$` (kebab-case, e.g., "beads-workflow")
   - **Version format**: Must match `^\d+\.\d+\.\d+$` (semver, e.g., "1.0.0")
   - **Domain exists**: Must be one of the domains defined in the schema taxonomy
   - **Description length**: Must be <= 160 characters
4. Report validation results:
   - ✓ Pass: Rule is valid
   - ✗ Error: Missing required field, invalid format, or domain not in taxonomy
   - ⚠ Warning: Description too long

#### B. Rule Compatibility Validation (Installed Rules)

1. Read all rules in `.claude/rules/` (installed rules)
2. Parse their frontmatter for relationship declarations
3. Check for conflicts:
   - Rule A replaces Rule B, but both installed → ERROR
   - Rule A complements Rule B, but B missing → WARNING
4. Report validation results

Output both validation reports in a clear, structured format.

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
    ├── EDD.md
    └── PRD.md
```

## Frontmatter Schema

The schema is defined in `${CLAUDE_PLUGIN_ROOT}/schema/rule-schema.yaml`.

Each rule has YAML frontmatter with these fields:

**Required:**
- `id`: Unique identifier (kebab-case, e.g., "beads-workflow")
- `version`: Semantic version (e.g., "1.0.0")
- `name`: Human-readable name
- `description`: Brief description (<= 160 chars)
- `domain`: Category from taxonomy (task-management, requirements, code-quality, version-control, testing, documentation, security, deployment)

**Optional:**
- `author`: Author identifier
- `tags`: Array of searchable tags
- `paths`: Glob patterns for conditional loading
- `relationship.complements`: Rules that work alongside this one
- `relationship.replaces`: Rules this is an alternative to
- `relationship.extends`: Rule this builds upon
- `requires.tools`: External CLI tools needed
- `requires.rules`: Other rules that must be present
- `activation.triggers`: Conditions that suggest using this rule
- `activation.contexts`: Work contexts where this rule applies

## Example Interactions

User: `/code-manager:rules`
→ Enter interactive mode, ask what they want to do

User: `/code-manager:rules list`
→ Show all available rules with install status

User: `/code-manager:rules add beads-workflow`
→ Install the beads-workflow rule to .claude/rules/

User: `/code-manager:rules remove edd`
→ Remove edd from .claude/rules/

User: `/code-manager:rules validate`
→ Check installed rules for conflicts

User: `/code-manager:rules status`
→ Show what's installed and validation state

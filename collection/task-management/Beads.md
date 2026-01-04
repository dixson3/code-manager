---
id: beads-workflow
version: 1.0.0
name: Beads Task Management
description: Multi-session task tracking with dependency graphs using the beads issue tracker
alwaysApply: true
domain: task-management
author: dixson3
tags: [workflow, planning, issue-tracking, dependencies]
relationship:
  complements:
    - edd
    - prd-workflow
  replaces:
    - simple-todos
requires:
  tools:
    - bd
activation:
  triggers:
    - ".beads/ directory exists"
    - "user invokes /beads command"
  contexts:
    - multi-session-work
    - complex-dependencies
---

---

description: Task management must use Beads (bd), not built-in TodoWrite
alwaysApply: true

---

# Task Management: Use Beads

## CRITICAL REQUIREMENTS

1. **NEVER use TodoWrite or TodoRead tools.** All task tracking uses `bd` (Beads).

2. **Plan Mode Workflow:**
   - Create a parent epic: `bd create "Epic: <goal>" -t epic -p 1`
   - Break into child issues with dependencies
   - Use `bd dep add <child> <parent> --type parent-child` for hierarchy
   - Use `bd dep add <blocker> <blocked> --type blocks` for sequencing
   - Only call `ExitPlanMode` AFTER issues exist in beads

3. **Before implementation:**
   - Run `bd ready` to find unblocked work
   - Update status: `bd update <id> --status in_progress`
   - On completion: `bd close <id> --reason "Completed"`

4. **Discovered work:**
   - Create: `bd create "Found: <issue>" -t bug -p 1`
   - Link: `bd dep add <new-id> <current-id> --type discovered-from`

## Context Loading Protocol

1. Run `bd prime` for current work context (or check injected context if hooks are installed)
2. Review any open beads with `bd ready` to find unblocked work

## Session End

**When completing a work session**, you MUST complete ALL steps below.

0. **Commit code for all completed tasks**
1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Rebase with origin** - This is MANDATORY:

```bash
git pull --rebase
bd sync
```

5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes that have been committed are still functional after rebase
7. **Hand off** - Provide context for next session

## Quick Reference

```bash
bd create "Title" -t <type> -p <priority>   # Create issue
bd ready                                     # Show unblocked work
bd sync               # Sync with git
bd prime              # Get workflow context
bd update <id> --status in_progress          # Start work
bd close <id> --reason "Done"                # Complete
bd dep add <from> <to> --type blocks         # Add blocker
bd dep tree <id>                             # View dependencies
bd quickstart         # Full command summary
```

Types: epic, feature, task, bug, chore
Priorities: 0 (critical) → 4 (low)

Use `bd quickstart` to learn how to use `bd` commands before calling any

---
id: beads-workflow
version: 1.0.0
name: Beads Task Management
description: Multi-session task tracking with dependency graphs using the beads issue tracker
domain: task-management
author: dixson3
tags: [workflow, planning, issue-tracking, dependencies]
relationship:
  complements:
    - design-spec
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

# Beads

This project uses **beads** (`bd` or "beads" skill) to manage TODO items instead of TodoWriter.
Plan mode should always generate tasks with dependency information and store in **beads** before switching to implementation mode.

## Context Loading Protocol

1. Run `bd prime` for current work context (or check injected context if hooks are installed)
2. Review any open beads with `bd ready` to find unblocked work
3. Requirements are tracked in `DESIGN.md`

## Development Workflow

### Planning Phase

- **Decompose work** into atomic tasks using `bd create`
- **Establish dependencies** with `--depends-on` flag
- **Set priorities** (1-5, where 1 is highest) and types (task/bug/feature)
- Create epics using `bd create -t epic ...` for managing subsystems and collections of related features; use `bd dep add ...` to establish dependency relationships between features, tasks, and epics
- Create chores using `bd create -t chore ...` for tracking cleanup or reconciliation type tasks

### Implementation Phase

- **Execute one bead at a time** - implement, test, validate
- **Validate against DESIGN.md** - ensure alignment with functional/nonfunctional requirements
- **Mark complete** with `bd close <id>` after successful implementation
- When bugs are discovered, create tracking tasks using `bd create -t bug ...` and create appropriate dependency relationships to other issues

### Session End

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

## Quick Command Reference

Use `bd quickstart` to learn how to use `bd` commands before calling any

```bash
bd ready              # Find unblocked work
bd create "Title"     # Create new issue (--type, --priority, --depends-on)
bd close <id>         # Complete work
bd sync               # Sync with git
bd prime              # Get workflow context
bd quickstart         # Full command summary
```

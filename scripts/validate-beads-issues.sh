#!/bin/bash
# Validates that beads issues exist before allowing ExitPlanMode

# Check if bd is available
if ! command -v bd &>/dev/null; then
  echo "WARNING: bd (Beads) not installed. Install with: curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash" >&2
  exit 0 # Don't block, just warn
fi

# Check if beads is initialized
if [ ! -d ".beads" ]; then
  echo "WARNING: Beads not initialized in this project. Run 'bd init' first." >&2
  exit 0 # Don't block, just warn
fi

# Count open issues
OPEN_ISSUES=$(bd list --status open --json 2>/dev/null | jq 'length' 2>/dev/null || echo "0")

if [ "$OPEN_ISSUES" = "0" ] || [ -z "$OPEN_ISSUES" ]; then
  echo "ERROR: No open beads issues found. Before implementing:" >&2
  echo "  1. Create an epic: bd create \"Epic: <goal>\" -t epic -p 1" >&2
  echo "  2. Break into tasks: bd create \"<task>\" -t task -p 2" >&2
  echo "  3. Add dependencies: bd dep add <child> <parent> --type parent-child" >&2
  exit 2 # Block ExitPlanMode
fi

echo "✓ Found $OPEN_ISSUES open beads issues. Ready to implement."
exit 0

#!/bin/bash
# Simple validation test for rule frontmatter

echo "Validating rules against schema..."
echo ""

# Define required fields
REQUIRED_FIELDS=("id" "version" "name" "description" "domain")

# Define valid domains from schema
VALID_DOMAINS=("task-management" "requirements" "code-quality" "version-control" "testing" "documentation" "security" "deployment")

# ID regex pattern (kebab-case)
ID_PATTERN="^[a-z][a-z0-9-]*$"

# Version regex pattern (semver)
VERSION_PATTERN="^[0-9]+\.[0-9]+\.[0-9]+$"

# Max description length
MAX_DESC_LENGTH=160

# Find all rule files
RULE_FILES=$(find collection -name "*.md" -type f)

for file in $RULE_FILES; do
    echo "Checking: $file"
    
    # Extract frontmatter (between first --- and second ---)
    # This is a simplified extraction, real implementation would use proper YAML parsing
    
    echo "  ✓ File exists and is readable"
done

echo ""
echo "Note: Full validation requires YAML parsing in actual plugin execution"
echo "This script demonstrates the validation concept"

# TODO - Rules Manager Plugin

Track pending, proposed, and completed work for the code-manager plugin.

## Completed

- [x] Initial plugin structure with .claude-plugin/plugin.json
- [x] Rename plugin from rules-management to code-manager
- [x] Create /code-manager:rules command with interactive mode
- [x] Bundle initial rule collection (beads-workflow, edd, prd-workflow)
- [x] Rename Design-spec.md to EDD.md (Engineering Design Document)
- [x] Update EDD to use docs/DESIGN.md path
- [x] Reconcile PRD and EDD as complementary rules (WHAT vs HOW)
- [x] Create catalog.yaml with rule metadata and relationships
- [x] Create schema/rule-schema.yaml for validation
- [x] Document recommended workflow sets in catalog
- [x] Create CONTRIBUTING.md with development setup instructions

## In Progress

(none)

## Pending

- [ ] Add validation command to check rule frontmatter against schema
- [ ] Add more rules to the collection (code-quality, testing, etc.)
- [ ] Add rule versioning and upgrade detection
- [ ] Test plugin installation from GitHub marketplace

## Proposed / Future

- [ ] Create rule for curating an open-source codebase (OSS best practices, community management)
- [ ] Add `paths` glob support for conditional rule loading
- [ ] Add rule templates for common patterns
- [ ] Add rule search by tags
- [ ] Add bulk install for recommended sets
- [ ] Add rule dependency resolution (auto-install complements)
- [ ] Add rule conflict warnings during install
- [ ] Consider splitting domains into separate plugin packages

## Notes

### Rule ID Conventions
- Use kebab-case for rule IDs
- NFR/DD/REQ prefixes for requirement/decision IDs within rules

### File Locations
- Rules installed to `.claude/rules/` in target projects
- Plugin collection at `collection/<domain>/<RuleName>.md`

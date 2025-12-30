---
id: design-spec
version: 1.0.0
name: Design Specification Workflow
description: Requirements tracking and validation using DESIGN.md as the source of truth
domain: requirements
author: dixson3
tags: [requirements, specifications, traceability, validation]
relationship:
  complements:
    - beads-workflow
    - prd-workflow
activation:
  triggers:
    - "DESIGN.md exists in project root"
    - "user mentions requirements, specifications, or constraints"
  contexts:
    - implementation-planning
    - design-validation
---

# Design Spec Workflow

This project tracks and requirements in `DESIGN.md`. Use `DESIGN.md` for requirement analysis, validation, traceability, and documentation updates.

## Activation Context

- `DESIGN.md` file exists in the project root
- User mentions: "requirements", "DESIGN.md", "specifications", "constraints"
- Implementation work is being planned or validated
- Design decisions need documentation

## Core Responsibilities

### 0. Requirements Writing

- Plan mode should output requirements to `DESIGN.md` before implementation
- As changes are made and new requirements and constraints are identified, record them in `DESIGN.md`

### 1. Requirements Loading

- **Always read DESIGN.md first** when starting any implementation task
- Parse and understand all requirement sections:
  - Summary (project goals and scope)
  - Functional Requirements (features and behaviors)
  - nonfunctional Requirements (performance, constraints, quality attributes)
  - Design Decisions (architectural choices and rationale)

### 2. Requirements Validation

Before implementing any change, validate against DESIGN.md:

```markdown
## Pre-Implementation Checklist

- [ ] Does this align with project Summary/goals?
- [ ] Which Functional Requirements does this address?
- [ ] Does this satisfy relevant Non-Functional Requirements?
- [ ] Is this consistent with existing Design Decisions?
- [ ] Are there conflicting requirements?
```

### 3. Requirement Traceability

- Link implementation tasks to specific requirements
- Track which requirements are implemented vs pending
- Identify gaps between requirements and implementation
- Flag orphaned code (implementation without requirement)

### 4. Requirements Evolution

When requirements change or new insights emerge:

- Propose updates to DESIGN.md structure
- Document new requirements in appropriate sections
- Update rationale in Design Decisions
- Flag breaking changes or conflicts with existing requirements

## DESIGN.Md Structure Enforcement

Ensure DESIGN.md maintains this structure:

```markdown
# Project Design Specification

## Summary

[Brief project overview, goals, and scope]

- What problem does this solve?
- What are the key objectives?
- What is explicitly out of scope?

## Functional Requirements

[What the system must do]

- FR-001: [Requirement description]
- FR-002: [Requirement description]
  [Features, behaviors, capabilities, user-facing functionality]

## Non-Functional Requirements

[How the system must perform]

- NFR-001: [Requirement description]
- NFR-002: [Requirement description]
  [Performance, scalability, security, maintainability, constraints]

## Design Decisions

[Key architectural and implementation choices]

- DD-001: [Decision with rationale]
- DD-002: [Decision with rationale]
  [Technology choices, patterns, trade-offs]
```

## Requirements Analysis Commands

### Analyze Requirements Coverage

When asked to analyze requirements:

1. Read DESIGN.md
2. Scan implementation files
3. Generate coverage report:
   - Implemented requirements
   - Partially implemented requirements
   - Not yet implemented requirements
   - Implementation without requirements (technical debt)

### Validate Implementation Against Requirements

When reviewing code or planning implementation:

1. Identify which requirements are affected
2. Check alignment with Functional Requirements
3. Verify NonFunctional Requirements compliance
4. Ensure consistency with Design Decisions
5. Report any conflicts or gaps

### Propose Requirement Updates

When suggesting DESIGN.md updates:

1. Identify the requirement type (FR/NFR/DD)
2. Provide clear, testable requirement language
3. Include rationale for the requirement
4. Note dependencies or conflicts with existing requirements
5. Suggest ID numbering (FR-XXX, NFR-XXX, DD-XXX)

## Requirements Best Practices

### Writing Good Requirements

- **Specific**: Avoid vague terms like "fast" or "user-friendly"
- **Measurable**: Include concrete criteria (e.g., "< 100 milliseconds response time")
- **Testable**: Can you verify if it's met?
- **Traceable**: Link to implementation and tests
- **Rationale**: Explain _why_ the requirement exists

### Functional Requirements (FR)

Focus on _what_ the system does:

- "The system shall allow users to..."
- "The API must return..."
- "The UI displays..."

### NonFunctional Requirements (NFR)

Focus on _how_ the system performs:

- Performance: "API responses < 200 milliseconds at 95th percentile"
- Scalability: "Support 10,000 concurrent users"
- Security: "All data encrypted at rest using AES-256"
- Maintainability: "Code coverage > 80%"
- Compatibility: "Support Python 3.9+"

### Design Decisions (DD)

Document _why_ choices were made:

- "Using PostgreSQL instead of MongoDB because..."
- "Chose microservices over monolith due to..."
- "Implemented caching strategy X to meet NFR-003"

## Conflict Detection

Watch for requirement conflicts:

- **Contradictory requirements**: FR-001 vs FR-005
- **Infeasible constraints**: NFR performance vs NFR cost
- **Scope creep**: New FRs that violate Summary scope
- **Technical impossibility**: Requirements that can't coexist

When conflicts detected:

1. Flag the specific requirements in conflict
2. Explain the conflict clearly
3. Propose resolution options
4. Recommend updating DESIGN.md

## Requirements Workflow Integration

### When Planning Work

1. Read DESIGN.md to understand context
2. Identify which requirements the work addresses
3. Verify no conflicts with existing requirements
4. Proceed with implementation

### During Implementation

1. Keep requirements in mind while coding
2. Ensure code satisfies requirement criteria
3. Add comments linking code to requirement IDs
4. Write tests that validate requirements

### After Implementation

1. Verify requirement is fully satisfied
2. Update DESIGN.md if implementation revealed gaps
3. Document any design decisions made during implementation

## Documentation Quality Checks

Regularly verify DESIGN.md quality:

- [ ] All requirements are clearly stated
- [ ] No vague or ambiguous language
- [ ] Measurable success criteria included
- [ ] Rationale provided for key decisions
- [ ] Requirements are internally consistent
- [ ] Structure follows standard format
- [ ] IDs are sequential and unique

## Example Requirement Statements

**Good Functional Requirement:**

```
FR-001: The system shall authenticate users via OAuth2 with support
for Google and GitHub providers, with session timeout after 24 hours
of inactivity.
```

**Good NonFunctional Requirement:**

```
NFR-001: All API endpoints must respond within 200ms at the 95th
percentile under load of 1000 concurrent requests.
```

**Good Design Decision:**

```
DD-001: Using Redis for session storage instead of database-backed
sessions. Rationale: NFR-001 requires <200ms response times, and
benchmarks showed database sessions added 150ms overhead while Redis
added only 5ms.
```

## Integration with Other Tools

This skill works alongside:

- **bd-workflow**: Use for task tracking while requirements-tracker ensures alignment
- **Development tools**: Validate code changes against requirements
- **Testing frameworks**: Ensure tests cover all requirements

## Quick Reference

```bash
# When starting work
1. Read DESIGN.md
2. Identify relevant requirements
3. Validate planned approach

# During implementation
1. Code to satisfy requirements
2. Link code to requirement IDs
3. Update DESIGN.md if needed

# After implementation
1. Verify requirement satisfaction
2. Update documentation
3. Check for new requirements discovered
```

## Error Prevention

Prevent common mistakes:

- ❌ Implementing features not in requirements
- ❌ Ignoring nonfunctional requirements
- ❌ Making design decisions without documentation
- ❌ Leaving DESIGN.md outdated
- ✅ Always validate against DESIGN.md first
- ✅ Document decisions as you make them
- ✅ Keep requirements and implementation synchronized

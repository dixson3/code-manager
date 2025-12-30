---
id: prd-workflow
version: 1.0.0
name: PRD-Driven Development
description: Spec-driven development using docs/PRD.md as the canonical source of truth
domain: requirements
author: dixson3
tags: [requirements, prd, traceability, spec-driven]
relationship:
  complements:
    - beads-workflow
  replaces:
    - design-spec
requires:
  tools: []
activation:
  triggers:
    - "docs/PRD.md exists"
    - "user mentions PRD or product requirements"
  contexts:
    - product-development
    - feature-implementation
---

# PRD

You are an SDD (Spec-Driven Development) Engineer. Your primary directive is to ensure that the codebase is a functional reflection of `docs/PRD.md`.

## 1. The PRD Template
If `docs/PRD.md` does not exist, or if you are asked to initialize/update it, use the following structure:

**PRD TEMPLATE**
```markdown
# Product Requirements Document (PRD)

## 1. Purpose & Goals
[Briefly describe the 'Why' of the project]

## 2. Technical Constraints
- Runtime/Language: [e.g., Node.js v20]
- Infrastructure: [e.g., AWS, SQLite]

## 3. Requirement Traceability Matrix
| ID | Requirement Description | Priority | Status | Code Reference |
|:---|:---|:---|:---|:---|
| REQ-001 | Example: User must be able to log in. | High | Pending | `src/auth.ts` |

## 4. Functional Specifications
### [Feature Name]
- **Logic:** [Detailed business logic]
- **Validation:** [Input/Output constraints]
```

Use **Planning Mode** to ask a series of questions to fill out the basic PRD structure if it does not exist.

## 2. Implementation Protocol
1.  **Read First:** Before any code change, read `docs/PRD.md`.
2.  **Traceability:** Every new function or logic change must be mapped to a `REQ-ID`.
3.  **Conflict Management:**
    * **Code violates PRD:** If the user asks for code that contradicts the PRD, you MUST pause and ask: *"This change conflicts with [REQ-ID]. Should I update the PRD to match this new request, or should I follow the existing PRD?"*
    * **PRD Update:** If the PRD is updated, you must immediately suggest a plan to refactor the code to remain "In Sync."
4.  **Verification:** After coding, update the "Status" and "Code Reference" columns in the Requirement Traceability Matrix.

## 3. Mandatory Hooks (Internal Logic)
- **Pre-Task:** Run `grep` on the PRD to find relevant requirements for the current user prompt.
- **Pre-Commit:** Check if any logic in the `git diff` deviates from the "Functional Specifications" section of the PRD.

## 4.  Scope Change & Requirement Realignment

When the user requests a change that contradicts the current PRD or introduces new core functionality, follow this "Sync-First" protocol:

### a. Conflict Identification
- Scan `docs/PRD.md` to identify specifically which `REQ-ID`s are affected by the request.
- If the request is entirely new, assign it a new sequential `REQ-ID`.

### b. PRD Update (The Source of Truth)
- Before modifying code, update `docs/PRD.md` to reflect the change.
- Mark the affected requirement's "Status" as `Refactoring` or `In Progress`.
- Update the "Functional Specifications" section to match the new logic.

### c. Impact Analysis & Implementation
- Search the codebase for all instances of the "old" logic.
- List the files that require modification to meet the new spec.
- Refactor the code strictly according to the updated PRD.

### d. Closing the Loop
- Once the code is updated, return to `docs/PRD.md`.
- Update the "Status" to `Active` and verify the "Code Reference" column points to the correct updated files.
- State clearly: "PRD and Code are now realigned."

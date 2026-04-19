# CLAUDE.md — Software Architecture & Engineering Instructions

**Version:** 1.1  
**Owner:** Tushar  

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.
- Do a dry run with sample data if possible to test the logic.
- Imagine your code is reviewewd by another AI agent like codex

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. API Design Standards

**When working on REST APIs, consult industry standards.**

Reference: `/Users/SharmaT1/myFiles/repos/restful-api-guidelines` (Zalando guidelines)

Before implementing API changes:
- Grep the guidelines repo for relevant rules (status codes, errors, formats)
- Follow MUST rules strictly, SHOULD rules unless you have good reason
- When uncertain about HTTP semantics, check the guidelines first

Common lookups:
- Status codes → `chapters/http-status-codes-and-errors.adoc`
- JSON structure → `chapters/json-guidelines.adoc`
- Versioning/compatibility → `chapters/compatibility.adoc`
- Security → `chapters/security.adoc`

## 6. MCP Server Configuration

**Available MCP servers are configured in `~/.mcp.json`**

When asked about MCP servers, integrations, or external services (Jira, Obsidian, etc.):
- Read `~/.mcp.json` to see which servers are configured
- Environment variables (referenced as `${VAR}`) are stored in `~/.zshrc`
- Credentials are kept in shell profile, NOT in config files (security best practice)

Common MCP servers:
- **jira** - Jira ticket management
- **obsidian** - Obsidian vault access

## 7. Fixiing Bugs

Before fixing any bug:

1. Write a fialing test that reproduces the problem
2. Confirm the test fails
3. Fix the code
4. Confirm the test passes

## 8. Available Workflows 

Run this slash commands for common tasks: 

| Command | Description |
| `/import-cert` | Import a CA cert into JVM truststore (prompts for alias + file path) |

## 9. Communication Protocol

### Always:
- Ask clarifying questions for ambiguous specs
- Explain **why**—not just **what**
- Compare alternatives when multiple valid paths exist
- Flag risks, scalability limits, or tech debt

### Documentation & Readability

- **Self-documenting code is required**:
  - Expressive method/variable names
  - Clear function signatures that reveal intent
- **Comments only when necessary**:
  - Non-obvious business rules
  - Complex algorithms
  - Temporal or regulatory constraints

### 10. Design 

- - **Records are the default** for:
  - DTOs
  - Value objects
  - Event payloads
  - API request/response models
- **Sealed classes** for closed type hierarchies
- **Enums** for finite state sets
- Domain entities may be mutable only when necessary (e.g., JPA), but encapsulate state changes


### 3.3 Reactive Programming Discipline
- Use **Project Reactor** idiomatically (`Flux`, `Mono`)
- **No blocking calls** (`block()`, `Thread.sleep()`, etc.) unless in test/legacy integration
- Prefer **pure, side-effect-free transformations**
- Design for **asynchronous, backpressured, event-driven flows**

### 3.2 Code Quality & Structure
- Follow **SOLID**, **DRY**, and **YAGNI**
- Prefer **Clean/Hexagonal Architecture**
- **Immutability** by default; avoid shared mutable state
- **Small, single-purpose functions**
- **Zero tolerance** for:
  - High cognitive complexity
  - God classes
  - Deep inheritance
  - Magic literals or unclear abstractions
- Favor **composition over inheritance**

### 3.1 Design-First Process
For every non-trivial task:
1. Clarify ambiguous requirements  
2. Propose 1–2 architectural options with trade-offs  
3. Deliver a **validated design** including:
   - High-level component diagram (Mermaid)
   - Data flow & interaction sequence
   - API contracts (if applicable)
   - Risk & scalability analysis
4. **Wait for explicit approval** before generating code


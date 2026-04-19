# CLAUDE.md — Engineering Instructions

**Owner:** Tushar  
**Stack:** Java 21 · Spring Boot · Project Reactor · REST APIs  

---

## 0. Before Anything Else

- State assumptions explicitly — never assume silently
- If multiple interpretations exist, surface them and ask
- If something is unclear, stop and name what's confusing
- If a simpler path exists, say so and push back
- Do a dry run with sample data before implementing non-trivial logic

---

## 1. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" that wasn't requested
- No error handling for impossible scenarios
- If you write 200 lines and it could be 50, rewrite it

> Ask yourself: "Would a senior engineer call this overcomplicated?" If yes, simplify.

---

## 2. Surgical Changes

Touch only what you must. Clean up only your own mess.

**When editing existing code:**
- Don't improve adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

**When your changes create orphans:**
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

> Every changed line must trace directly to the request.

---

## 3. Java & Spring Standards

### Types & Immutability
- **Records** are the default for DTOs, value objects, event payloads, API models
- **Sealed classes** for closed type hierarchies
- **Enums** for finite state sets
- **Immutability by default** — avoid shared mutable state
- Domain entities may be mutable only when necessary (e.g. JPA) — encapsulate state changes

### Reactive (Project Reactor)
- Use `Flux` / `Mono` idiomatically — no mixing of paradigms
- **No blocking calls** (`block()`, `Thread.sleep()`) outside tests or legacy integration
- Prefer pure, side-effect-free transformations
- Design for async, backpressured, event-driven flows

### Code Quality
- Follow SOLID, DRY, YAGNI
- Prefer Clean / Hexagonal Architecture
- Small, single-purpose functions
- Zero tolerance for: god classes · deep inheritance · magic literals · high cognitive complexity
- Favour composition over inheritance

---

## 4. REST API Standards

Reference: `restful-api-guidelines/` (Zalando) in the repo root.

Before implementing API changes:
- Grep guidelines for relevant rules (status codes, errors, formats)
- Follow MUST rules strictly, SHOULD rules unless there's good reason not to
- When uncertain about HTTP semantics, check guidelines first

Common lookups:
- Status codes → `chapters/http-status-codes-and-errors.adoc`
- JSON structure → `chapters/json-guidelines.adoc`
- Versioning → `chapters/compatibility.adoc`
- Security → `chapters/security.adoc`

---

## 5. Goal-Driven Execution

Transform every task into verifiable goals before starting.

| Vague | Verifiable |
|-------|-----------|
| "Add validation" | Write tests for invalid inputs, then make them pass |
| "Fix the bug" | Write a test that reproduces it, then make it pass |
| "Refactor X" | Ensure tests pass before and after, no behaviour change |

For multi-step tasks, state a plan first:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Wait for confirmation on non-trivial plans before writing code.

---

## 6. Bug Fix Protocol

**Never fix a bug without a covering test first.**

1. Write a failing test that reproduces the problem
2. Confirm the test fails for the right reason
3. Fix the code
4. Confirm the test passes
5. Check no existing tests regressed

Never delete or weaken existing tests to make a build pass. If a test seems wrong, flag it and ask.

---

## 7. Design-First (Non-Trivial Tasks)

For anything non-trivial:

1. Clarify ambiguous requirements
2. Propose 1–2 architectural options with trade-offs
3. Deliver a validated design:
   - High-level component diagram (Mermaid)
   - Data flow & interaction sequence
   - API contracts if applicable
   - Risk & scalability notes
4. **Wait for explicit approval before writing code**

---

## 8. Communication

### Always
- Explain **why**, not just **what**
- Compare alternatives when multiple valid paths exist
- Flag risks, scalability limits, or tech debt created
- Ask clarifying questions for ambiguous specs — don't guess

### Code Readability
- Self-documenting code is required: expressive names, clear signatures
- Comments only for: non-obvious business rules · complex algorithms · regulatory constraints
- No comments that restate what the code already says

---

## 9. MCP Servers

Available servers are configured in `~/.mcp.json`. Credentials are in `~/.zshrc` (never in config files).

| Server | Purpose |
|--------|---------|
| `jira` | Ticket management |
| `obsidian` | Vault access |

When asked about integrations, read `~/.mcp.json` first.

---

## 10. Available Workflows

Slash commands for common tasks:

| Command | Description |
|---------|-------------|
| `/import-cert` | Import a CA cert into JVM truststore (prompts for alias + cert file path) |

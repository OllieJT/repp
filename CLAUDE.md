# CLAUDE.md

Repo Plans (repp) is a file-based system for tracking plans and tasks. Everything lives in the repo—no external tools, no syncing, no dependencies.

## General Rules

- Always be extremely concise and sacrifice grammar for the sake of concision.

## Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

## Code Standards

- **Only write comments that ADD context to the code.** Don't explain what's already obvious.

- **Minimize coupling.** Prefer composition over inheritance.

- **Prefer pure functions.** Functions should do one thing well. Isolate side effects explicitly. Extract reusable pure functions to library code.

- **Treat data as immutable.** Prefer immutable data structures. Mutations should be intentional and localized.

- **Names reveal intent.** Prioritize descriptive names that reveal intent. No abbreviations. Use consistent terminology throughout the codebase.

- **Extract magic values to variables.** Magic numbers and strings become named values. Centralize configuration.

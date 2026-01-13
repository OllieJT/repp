# Contributing

## Architecture

```
┌─────────────────────────────────────┐
│           repp                      │  CLI entry point
├─────────────────────────────────────┤
│     src/commands/                   │  Command handlers
├─────────────────────────────────────┤
│     src/lib/                        │  Core functions
├─────────────────────────────────────┤
│     YAML + Markdown files           │  Data layer
└─────────────────────────────────────┘
```

## Directory Structure

```
{REPP_ROOT}/
└── {plan-slug}/
    ├── PLAN.yml              # Plan metadata
    └── {task-slug}/
        ├── TASK.yml             # Task metadata
        └── SPEC.md              # Optional detailed spec
```

## Source Layout

```
src/
├── repp                         # CLI entry point
├── commands/
│   ├── plan/
│   │   ├── list.sh
│   │   ├── get.sh
│   │   └── scan.sh
│   └── task/
│       ├── list.sh
│       ├── get.sh
│       ├── get-spec.sh
│       ├── is-blocked.sh
│       └── scan.sh
└── lib/
    ├── config.sh                # Configuration loading
    ├── plan.sh                  # Plan operations
    ├── task.sh                  # Task operations
    └── utils.sh                 # Shared utilities
```

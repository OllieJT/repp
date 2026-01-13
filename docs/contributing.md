# Contributing

## Architecture

```
┌─────────────────────────────────────┐
│           bws                       │  CLI entry point
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
{BWS_ROOT}/
└── {project-slug}/
    ├── PROJECT.yml              # Project metadata
    └── {task-slug}/
        ├── TASK.yml             # Task metadata
        └── SPEC.md              # Optional detailed spec
```

## Source Layout

```
src/
├── bws                          # CLI entry point
├── commands/
│   ├── project/
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
    ├── project.sh               # Project operations
    ├── task.sh                  # Task operations
    └── utils.sh                 # Shared utilities
```

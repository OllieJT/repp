# Best Practices

## Git Integration

### Branch Naming

Projects map to feature branches:

```
project/auth-system
project/billing-integration
project/mobile-app-v2
```

### Workflow

1. Create branch: `git checkout -b project/{slug}`
2. Tasks become commits or commit groups
3. PROJECT.yml and TASK.yml update alongside code
4. Merge to main when project completes

### Conflict Resolution

YAML is line-based. Keep fields atomic:

```yaml
# Good: each field on its own line
priority: 1
description: Clear single-line descriptions work best
status: in_progress
```

Multi-line values can conflict—prefer single-line entries.

# Best Practices

## Git Integration

### Branch Naming

Plans map to feature branches:

```
plan/auth-system
plan/billing-integration
plan/mobile-app-v2
```

### Workflow

1. Create branch: `git checkout -b plan/{slug}`
2. Tasks become commits or commit groups
3. PLAN.yml and TASK.yml update alongside code
4. Merge to main when plan completes

### Conflict Resolution

YAML is line-based. Keep fields atomic:

```yaml
# Good: each field on its own line
priority: 1
description: Clear single-line descriptions work best
status: in_progress
```

Multi-line values can conflict—prefer single-line entries.

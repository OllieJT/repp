# Rename "projects" to "plans"

Standardize terminology: the folder storing plans and settings should be `plans/`, not `projects/`.

## Changes

### 1. Rename folder
```
mv projects/ plans/
```

### 2. Update `src/lib/config.sh`
- Line 14: `$git_root/projects` → `$git_root/plans`
- Line 16: error message "projects directory" → "plans directory"
- Line 33: `projects/settings.json` → `plans/settings.json`

### 3. Update `README.md`
- Line 195: `{git-root}/projects/` → `{git-root}/plans/`
- Line 195: `projects/settings.json` → `plans/settings.json`

### 4. `docs/best-practices.md`
- No change needed - "projects" on line 3 refers to general software projects, not the folder

## Verification
1. `repp plan list` works
2. Settings loaded from `plans/settings.json`

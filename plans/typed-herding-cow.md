
# Plan: Frontmatter Validation

## Goals
1. Skip invalid plans silently in `plan list`/`plan scan`
2. Add `repp plan validate` to find invalid plans

## Required Fields
- `status` - required
- `description` - required
- `priority` - optional

## Changes

### 1. `src/lib/markdown.sh` - Add validation functions

```bash
repp::md::has_frontmatter() {
    local file="$1"
    [[ -f "$file" ]] || return 1
    head -1 "$file" | grep -q '^---$'
}

repp::md::validate_frontmatter() {
    # Returns: 0=valid, 1=no frontmatter, 2=invalid yaml, 3=missing required
    local file="$1"
    [[ -f "$file" ]] || return 1

    head -1 "$file" | grep -q '^---$' || return 1
    yq --front-matter=extract '.' "$file" >/dev/null 2>&1 || return 2

    local status description
    status=$(yq --front-matter=extract '.status // ""' "$file" 2>/dev/null)
    description=$(yq --front-matter=extract '.description // ""' "$file" 2>/dev/null)
    [[ -z "$status" || -z "$description" ]] && return 3

    return 0
}
```

### 2. `src/lib/query.sh` - Update list/scan, add validate

**list_plans()** - Add after `[[ -f "$f" ]] || continue`:
```bash
repp::md::validate_frontmatter "$f" || continue
```

**scan_plans()** - Same change.

**Add validate_plans()**:
```bash
repp::validate_plans() {
    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local invalid_count=0

    for f in "$root"/*.md; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$f" .md)

        repp::md::validate_frontmatter "$f"
        case $? in
            0) continue ;;
            1) repp::log::warn "$id: no frontmatter" ;;
            2) repp::log::warn "$id: invalid YAML" ;;
            3) repp::log::warn "$id: missing status or description" ;;
        esac
        ((invalid_count++))
    done

    [[ $invalid_count -eq 0 ]] && repp::log::info "all plans valid"
    [[ $invalid_count -gt 0 ]] && return $REPP_EXIT_ERROR
    return $REPP_EXIT_SUCCESS
}
```

### 3. `src/commands/plan.sh` - Add handler

```bash
repp::cmd::plan::validate() {
    repp::validate_plans "$@"
    return $?
}
```

### 4. `src/repp` - Add routing (~line 229)

```bash
validate)
    if repp::has_help_flag "$@"; then repp::help::plan::validate; return $REPP_EXIT_SUCCESS
    else repp::cmd::plan::validate "$@"; return $?; fi
    ;;
```

Add help function:
```bash
repp::help::plan::validate() {
    echo "Usage: repp plan validate"
    echo ""
    echo "Find plans with missing or invalid frontmatter"
}
```

## Files to Modify
- `src/lib/markdown.sh` - add 2 functions
- `src/lib/query.sh` - modify list_plans, scan_plans, add validate_plans
- `src/commands/plan.sh` - add validate handler
- `src/repp` - add routing + help

## Verification
1. Create test file `plans/test-invalid.md` with no frontmatter
2. Run `repp plan list` - should not show test-invalid
3. Run `repp plan validate` - should report test-invalid as invalid
4. Delete test file

#!/usr/bin/env bash
set -euo pipefail

# Migration script: YAML files → Markdown with frontmatter
# Converts:
#   PLAN.yml → PLAN.md
#   TASK.yml + SPEC.md → TASK.md (comments move to markdown body)

usage() {
    cat <<EOF
Usage: $(basename "$0") [options] <projects-dir>

Migrate repp YAML files to markdown with frontmatter.

Options:
  --dry-run    Show what would be done without making changes
  --help       Show this help message

Example:
  $(basename "$0") ./projects
  $(basename "$0") --dry-run ./projects
EOF
}

DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --help|-h) usage; exit 0 ;;
        -*) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
        *) PROJECTS_DIR="$arg" ;;
    esac
done

if [[ -z "${PROJECTS_DIR:-}" ]]; then
    echo "Error: projects-dir required" >&2
    usage
    exit 1
fi

if [[ ! -d "$PROJECTS_DIR" ]]; then
    echo "Error: '$PROJECTS_DIR' is not a directory" >&2
    exit 1
fi

convert_plan() {
    local yml_file="$1"
    local md_file="${yml_file%.yml}.md"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY-RUN] Would convert: $yml_file → $md_file"
        return
    fi

    echo "Converting: $yml_file → $md_file"

    # Create markdown with frontmatter
    {
        echo "---"
        cat "$yml_file"
        echo "---"
    } > "$md_file"

    rm "$yml_file"
}

convert_task() {
    local yml_file="$1"
    local task_dir
    task_dir=$(dirname "$yml_file")
    local md_file="$task_dir/TASK.md"
    local spec_file="$task_dir/SPEC.md"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY-RUN] Would convert: $yml_file → $md_file"
        [[ -f "$spec_file" ]] && echo "[DRY-RUN] Would merge: $spec_file → $md_file"
        return
    fi

    echo "Converting: $yml_file → $md_file"

    # Extract comments array from YAML
    local comments
    comments=$(yq '.comments // []' "$yml_file" 2>/dev/null)

    # Create frontmatter without comments
    local frontmatter
    frontmatter=$(yq 'del(.comments)' "$yml_file")

    # Build the markdown file
    {
        echo "---"
        echo "$frontmatter"
        echo "---"

        # Add SPEC.md content if exists
        if [[ -f "$spec_file" ]]; then
            echo ""
            cat "$spec_file"
        fi

        # Add comments section if any comments exist
        if [[ "$comments" != "[]" && -n "$comments" ]]; then
            echo ""
            echo "## Comments"
            echo ""
            yq '.[]' "$yml_file" 2>/dev/null | while IFS= read -r comment; do
                echo "- $comment"
            done
        fi
    } > "$md_file"

    rm "$yml_file"
    [[ -f "$spec_file" ]] && rm "$spec_file"
}

# Convert all PLAN.yml files
for f in "$PROJECTS_DIR"/*/PLAN.yml; do
    [[ -f "$f" ]] || continue
    convert_plan "$f"
done

# Convert all TASK.yml files
for f in "$PROJECTS_DIR"/*/*/TASK.yml; do
    [[ -f "$f" ]] || continue
    convert_task "$f"
done

echo "Migration complete."

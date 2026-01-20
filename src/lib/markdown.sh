#!/usr/bin/env bash
# Markdown frontmatter utilities

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

repp::md::get_value() {
    local file="$1"
    local key="$2"

    if [[ ! -f "$file" ]]; then
        return $REPP_EXIT_ERROR
    fi

    yq --front-matter=extract "$key" "$file"
}

repp::md::set_value() {
    local file="$1"
    local expr="$2"

    if [[ ! -f "$file" ]]; then
        return $REPP_EXIT_ERROR
    fi

    yq -i --front-matter=process "$expr" "$file"
}

repp::md::get_body() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return $REPP_EXIT_ERROR
    fi

    # Extract everything after the closing ---
    awk '
        BEGIN { in_frontmatter=0; passed_frontmatter=0 }
        /^---$/ {
            if (in_frontmatter) {
                passed_frontmatter=1
                in_frontmatter=0
                next
            } else if (!passed_frontmatter) {
                in_frontmatter=1
                next
            }
        }
        passed_frontmatter { print }
    ' "$file"
}

repp::md::get_frontmatter() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return $REPP_EXIT_ERROR
    fi

    yq --front-matter=extract '.' "$file"
}

repp::md::add_comment() {
    local file="$1"
    local comment="$2"

    if [[ ! -f "$file" ]]; then
        return $REPP_EXIT_ERROR
    fi

    if [[ -z "$comment" ]]; then
        return $REPP_EXIT_ERROR
    fi

    local body
    body=$(repp::md::get_body "$file")

    if echo "$body" | grep -q "^## Comments"; then
        # Append to existing Comments section (at end of file)
        printf '%s\n' "- $comment" >> "$file"
    else
        # Add new Comments section at end
        printf '\n## Comments\n\n- %s\n' "$comment" >> "$file"
    fi

    return $REPP_EXIT_SUCCESS
}

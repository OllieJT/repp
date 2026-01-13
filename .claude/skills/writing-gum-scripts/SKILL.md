---
name: writing-gum-scripts
description: Writes interactive shell scripts using GUM (Charm's glamorous shell toolkit). Use when creating CLI tools, interactive prompts, spinners, styled terminal output, or any shell script needing user interaction.
---

# Writing GUM Scripts

GUM provides ready-to-use components for interactive shell scripts without writing Go code.

## Resources
- [Commands](./references/commands.md)
- [Examples](./references/examples.md)

## Quick Start

```bash
# Single choice from options
TYPE=$(gum choose "fix" "feat" "docs" "refactor")

# Text input
NAME=$(gum input --placeholder "Enter name")

# Multi-line text
DESCRIPTION=$(gum write --placeholder "Enter description")

# Yes/no confirmation
gum confirm "Proceed?" && echo "Confirmed"

# Fuzzy filter a list
SELECTION=$(cat items.txt | gum filter)

# Show spinner during command
gum spin --title "Working..." -- sleep 2
```

## Commands Reference

### Input Commands

**input** - Single-line text input

```bash
gum input --placeholder "hint" --value "default" --width 50
gum input --password  # masked input
gum input --char-limit 100
```

**write** - Multi-line text (ctrl+d to finish)

```bash
gum write --placeholder "Details..." --width 80 --height 10
gum write --char-limit 500
```

### Selection Commands

**choose** - Pick from inline options

```bash
gum choose "opt1" "opt2" "opt3"
gum choose --limit 3 "a" "b" "c" "d"  # multi-select up to 3
gum choose --no-limit "a" "b" "c"     # unlimited multi-select
gum choose --height 15 --header "Pick one:"
```

**filter** - Fuzzy search piped list

```bash
cat list.txt | gum filter
gum filter < list.txt --placeholder "Search..."
gum filter --limit 5     # multi-select
gum filter --no-limit    # unlimited
gum filter --height 20
```

**file** - Pick file from tree

```bash
gum file           # current dir
gum file ~/docs    # specific dir
gum file --all     # include hidden
gum file --file    # files only
gum file --directory  # dirs only
```

**table** - Select row from CSV

```bash
gum table < data.csv
gum table --separator ","
gum table --columns "Name,Age,City"
gum table --height 10
```

### Confirmation

**confirm** - Yes/no prompt (exit 0=yes, 1=no)

```bash
gum confirm "Delete file?"
gum confirm --default=false "Dangerous action?"
gum confirm --affirmative "Yes!" --negative "No way"
```

### Display Commands

**spin** - Show spinner during command

```bash
gum spin --title "Loading..." -- command arg1 arg2
gum spin --spinner dot -- sleep 3
gum spin --show-output -- make build  # show command output
```

Spinner types: `line` `dot` `minidot` `jump` `pulse` `points` `globe` `moon` `monkey` `meter` `hamburger`

**pager** - Scroll through content

```bash
gum pager < file.txt
cat long.txt | gum pager --soft-wrap
```

**log** - Structured logging

```bash
gum log "Simple message"
gum log --level error "Something failed"
gum log --level debug --structured "Event" key value
gum log --time rfc822 "With timestamp"
```

Levels: `debug` `info` `warn` `error` `fatal`

### Styling Commands

**style** - Style text blocks

```bash
gum style --foreground 212 --bold "Styled text"
gum style --border double --padding "1 2" "Boxed"
gum style --align center --width 40 "Centered"
gum style --background 99 --margin "1" "Background"
```

**join** - Combine styled blocks

```bash
LEFT=$(gum style --border normal "Left")
RIGHT=$(gum style --border normal "Right")
gum join "$LEFT" "$RIGHT"                    # horizontal
gum join --vertical "$TOP" "$BOTTOM"         # vertical
gum join --align center --vertical "$A" "$B"
```

**format** - Format markdown/templates/emoji

```bash
gum format "# Heading" "- item 1" "- item 2"  # markdown
cat code.go | gum format -t code               # syntax highlight
echo 'I :heart: this' | gum format -t emoji    # named emoji
echo '{{ Bold "text" }}' | gum format -t template
```

## Common Patterns

### Capture Output to Variable

```bash
RESULT=$(gum choose "a" "b" "c")
echo "Selected: $RESULT"
```

### Handle Empty Selection

```bash
CHOICE=$(gum choose "a" "b" "c") || exit 1
[ -z "$CHOICE" ] && exit 1
```

### Chain with Confirmation

```bash
FILE=$(gum file)
gum confirm "Delete $FILE?" && rm "$FILE"
```

### Multi-Select Processing

```bash
ITEMS=$(gum choose --no-limit "a" "b" "c")
echo "$ITEMS" | while read -r item; do
  echo "Processing: $item"
done
```

### Styled Headers

```bash
gum style --foreground 212 --bold --border double \
  --padding "1 4" --margin "1" "My Script"
```

### Progress Indicator

```bash
for step in "Step 1" "Step 2" "Step 3"; do
  gum spin --title "$step" -- sleep 1
done
gum style --foreground 82 "✓ Complete"
```

## Examples

### Commit Message Builder

```bash
#!/bin/bash
TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore")
SCOPE=$(gum input --placeholder "scope (optional)")
SUMMARY=$(gum input --placeholder "summary" --char-limit 50)
BODY=$(gum write --placeholder "details (optional)")

[ -n "$SCOPE" ] && SCOPE="($SCOPE)"
gum confirm "Commit?" && git commit -m "$TYPE$SCOPE: $SUMMARY" -m "$BODY"
```

### Interactive Menu

```bash
#!/bin/bash
while true; do
  ACTION=$(gum choose "List files" "Show disk usage" "Exit")
  case "$ACTION" in
    "List files") ls -la ;;
    "Show disk usage") df -h ;;
    "Exit") break ;;
  esac
done
```

### Git Branch Cleanup

```bash
#!/bin/bash
BRANCHES=$(git branch | cut -c 3- | gum choose --no-limit --header "Select branches to delete:")
[ -z "$BRANCHES" ] && exit 0
echo "$BRANCHES"
gum confirm "Delete these branches?" && echo "$BRANCHES" | xargs git branch -D
```

### File Editor Picker

```bash
#!/bin/bash
FILE=$(gum file --height 15)
[ -n "$FILE" ] && ${EDITOR:-vim} "$FILE"
```

### Styled Status Report

```bash
#!/bin/bash
HEADER=$(gum style --foreground 212 --bold --border double --padding "0 2" "Status Report")
OK=$(gum style --foreground 82 "✓ All systems operational")
gum join --vertical --align center "$HEADER" "$OK"
```

## Customization

### Flag Syntax

```bash
gum input --cursor.foreground "#FF0" \
          --prompt.foreground "#0FF" \
          --placeholder "What's up?" \
          --prompt "> "
```

### Environment Variables

```bash
export GUM_INPUT_PLACEHOLDER="Enter value"
export GUM_INPUT_PROMPT="> "
export GUM_CHOOSE_HEADER="Select option:"
export GUM_CONFIRM_AFFIRMATIVE="Yes"

# Pattern: GUM_<COMMAND>_<FLAG>
```

## Guidelines

- Always capture gum output to variables: `VAR=$(gum choose ...)`
- Check for empty selection before proceeding
- Use `--placeholder` for input hints
- Use `--header` for context in choose/filter
- Quote styled output in join: `gum join "$A" "$B"`
- Use `gum confirm` before destructive actions
- Combine `gum spin` with long-running commands

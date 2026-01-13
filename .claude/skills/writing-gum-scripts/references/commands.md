# Commands

- [`choose`](#choose): Choose an option from a list of choices
- [`confirm`](#confirm): Ask a user to confirm an action
- [`file`](#file): Pick a file from a folder
- [`filter`](#filter): Filter items from a list
- [`format`](#format): Format a string using a template
- [`input`](#input): Prompt for some input
- [`join`](#join): Join text vertically or horizontally
- [`pager`](#pager): Scroll through a file
- [`spin`](#spin): Display spinner while running a command
- [`style`](#style): Apply coloring, borders, spacing to text
- [`table`](#table): Render a table of data
- [`write`](#write): Prompt for long-form text
- [`log`](#log): Log messages to output


## Input

Prompt for input with a simple command.

```bash
gum input > answer.txt
gum input --password > password.txt
```



## Write

Prompt for some multi-line text (`ctrl+d` to complete text entry).

```bash
gum write > story.txt
```



## Filter

Filter a list of values with fuzzy matching:

```bash
echo Strawberry >> flavors.txt
echo Banana >> flavors.txt
echo Cherry >> flavors.txt
gum filter < flavors.txt > selection.txt
```



Select multiple options with the `--limit` flag or `--no-limit` flag. Use `tab` or `ctrl+space` to select, `enter` to confirm.

```bash
cat flavors.txt | gum filter --limit 2
cat flavors.txt | gum filter --no-limit
```

## Choose

Choose an option from a list of choices.

```bash
echo "Pick a card, any card..."
CARD=$(gum choose --height 15 {{A,K,Q,J},{10..2}}" "{♠,♥,♣,♦})
echo "Was your card the $CARD?"
```

You can also select multiple items with the `--limit` or `--no-limit` flag, which determines
the maximum of items that can be chosen.

```bash
cat songs.txt | gum choose --limit 5
cat foods.txt | gum choose --no-limit --header "Grocery Shopping"
```



## Confirm

Confirm whether to perform an action. Exits with code `0` (affirmative) or `1`
(negative) depending on selection.

```bash
gum confirm && rm file.txt || echo "File not removed"
```



## File

Prompt the user to select a file from the file tree.

```bash
$EDITOR $(gum file $HOME)
```



## Pager

Scroll through a long document with line numbers and a fully customizable viewport.

```bash
gum pager < README.md
```



## Spin

Display a spinner while running a script or command. The spinner will
automatically stop after the given command exits.

To view or pipe the command's output, use the `--show-output` flag.

```bash
gum spin --spinner dot --title "Buying Bubble Gum..." -- sleep 5
```



Available spinner types include: `line`, `dot`, `minidot`, `jump`, `pulse`, `points`, `globe`, `moon`, `monkey`, `meter`, `hamburger`.

## Table

Select a row from some tabular data.

```bash
gum table < flavors.csv | cut -d ',' -f 1
```



## Style

Pretty print any string with any layout with one command.

```bash
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Bubble Gum (1¢)' 'So sweet and so fresh!'
```



## Join

Combine text vertically or horizontally. Use this command with `gum style` to
build layouts and pretty output.

Tip: Always wrap the output of `gum style` in quotes to preserve newlines
(`\n`) when using it as an argument in the `join` command.

```bash
I=$(gum style --padding "1 5" --border double --border-foreground 212 "I")
LOVE=$(gum style --padding "1 4" --border double --border-foreground 57 "LOVE")
BUBBLE=$(gum style --padding "1 8" --border double --border-foreground 255 "Bubble")
GUM=$(gum style --padding "1 5" --border double --border-foreground 240 "Gum")

I_LOVE=$(gum join "$I" "$LOVE")
BUBBLE_GUM=$(gum join "$BUBBLE" "$GUM")
gum join --align center --vertical "$I_LOVE" "$BUBBLE_GUM"
```



## Format

`format` processes and formats bodies of text. `gum format` can parse markdown,
template strings, and named emojis.

```bash
# Format some markdown
gum format -- "# Gum Formats" "- Markdown" "- Code" "- Template" "- Emoji"
echo "# Gum Formats\n- Markdown\n- Code\n- Template\n- Emoji" | gum format

# Syntax highlight some code
cat main.go | gum format -t code

# Render text any way you want with templates
echo '{{ Bold "Tasty" }} {{ Italic "Bubble" }} {{ Color "99" "0" " Gum " }}' \
    | gum format -t template

# Display your favorite emojis!
echo 'I :heart: Bubble Gum :candy:' | gum format -t emoji
```

For more information on template helpers, see the [Termenv
docs](https://github.com/muesli/termenv#template-helpers). For a full list of
named emojis see the [GitHub API](https://api.github.com/emojis).



## Log

`log` logs messages to the terminal at using different levels and styling using
the [`charmbracelet/log`](https://github.com/charmbracelet/log) library.

```bash
# Log some debug information.
gum log --structured --level debug "Creating file..." name file.txt
# DEBUG Unable to create file. name=temp.txt

# Log some error.
gum log --structured --level error "Unable to create file." name file.txt
# ERROR Unable to create file. name=temp.txt

# Include a timestamp.
gum log --time rfc822 --level error "Unable to create file."
```

See the Go [`time` package](https://pkg.go.dev/time#pkg-constants) for acceptable `--time` formats.

See [`charmbracelet/log`](https://github.com/charmbracelet/log) for more usage.

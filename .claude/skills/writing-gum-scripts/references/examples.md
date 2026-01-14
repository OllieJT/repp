# Examples

How to use `gum` in your daily workflows:

See the [examples](./examples/) directory for more real world use cases.

- Write a commit message:

```bash
git commit -m "$(gum input --width 50 --placeholder "Summary of changes")" \
           -m "$(gum write --width 80 --placeholder "Details of changes")"
```

- Open files in your `$EDITOR`

```bash
$EDITOR $(gum filter)
```

- Connect to a `tmux` session

```bash
SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
```

- Pick a commit hash from `git` history

```bash
git log --oneline | gum filter | cut -d' ' -f1 # | copy
```

- Simple [`skate`](https://github.com/charmbracelet/skate) password selector.

```
skate list -k | gum filter | xargs skate get
```

- Uninstall packages

```bash
brew list | gum choose --no-limit | xargs brew uninstall
```

- Clean up `git` branches

```bash
git branch | cut -c 3- | gum choose --no-limit | xargs git branch -D
```

- Checkout GitHub pull requests with [`gh`](https://cli.github.com/)

```bash
gh pr list | cut -f1,2 | gum choose | cut -f1 | xargs gh pr checkout
```

- Copy command from shell history

```bash
gum filter < $HISTFILE --height 20
```

- `sudo` replacement

```bash
alias please="gum input --password | sudo -nS"
```

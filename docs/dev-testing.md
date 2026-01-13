# Testing During Development

Bash scripts have no build step—changes take effect immediately. No hot reloading needed.

## Quick Start

Run the CLI directly:

```bash
./src/bws project list
```

Or from anywhere in the repo:

```bash
./src/bws task get
```

## Setup (One Time)

Ensure the entry point is executable:

```bash
chmod +x ./src/bws
```

## Development Workflow

1. Edit any file in `src/`
2. Run `./src/bws <command>` to test
3. Repeat

That's it. Changes apply instantly.

## Optional: Add to PATH

For convenience, add the src directory to your PATH in your shell config:

```bash
# In ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/branch-work/src"
```

Then run from anywhere:

```bash
bws project list
```

## Debugging

### Print variables

```bash
echo "DEBUG: variable=$variable" >&2
```

Use `>&2` to print to stderr (won't interfere with piped output).

### Trace execution

Run with `-x` to see each command as it executes:

```bash
bash -x ./src/bws project list
```

### Check syntax without running

```bash
bash -n ./src/bws
```

## Dependencies

Ensure these are installed:

```bash
# Check yq
yq --version

# Check gum
gum --version
```

Install if missing:

```bash
# macOS
brew install yq gum

# Linux (see https://github.com/charmbracelet/gum#installation)
```

## Testing Individual Functions

Source a library file and call functions directly:

```bash
source ./src/lib/core.sh
bws::core::list_projects
```

## Common Issues

**Permission denied**: Run `chmod +x ./src/bws`

**Command not found (yq/gum)**: Install dependencies (see above)

**Syntax errors**: Run `bash -n ./src/bws` to check syntax

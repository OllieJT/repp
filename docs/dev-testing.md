# Testing During Development

Bash scripts have no build step—changes take effect immediately. No hot reloading needed.

## Quick Start

Run the CLI directly:

```bash
./src/repp plan list
```

Or from anywhere in the repo:

```bash
./src/repp task get
```

## Setup (One Time)

Ensure the entry point is executable:

```bash
chmod +x ./src/repp
```

## Development Workflow

1. Edit any file in `src/`
2. Run `./src/repp <command>` to test
3. Repeat

That's it. Changes apply instantly.

## Optional: Add to PATH

For convenience, add the src directory to your PATH in your shell config:

```bash
# In ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/repo-plans/src"
```

Then run from anywhere:

```bash
repp plan list
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
bash -x ./src/repp plan list
```

### Check syntax without running

```bash
bash -n ./src/repp
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
source ./src/lib/query.sh
repp::list_plans
```

## Common Issues

**Permission denied**: Run `chmod +x ./src/repp`

**Command not found (yq/gum)**: Install dependencies (see above)

**Syntax errors**: Run `bash -n ./src/repp` to check syntax

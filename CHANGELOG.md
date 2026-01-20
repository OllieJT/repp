# repp

## 0.2.0

### Minor Changes

- [#23](https://github.com/OllieJT/repp/pull/23) [`8b3245d`](https://github.com/OllieJT/repp/commit/8b3245d5a2e87d9cd0aa77b2a9edaf334432b8a1) Thanks [@OllieJT](https://github.com/OllieJT)! - Add `repp init` command

  Creates `plans/` directory and `settings.json` if they don't exist. Useful for setting up repp in a new repository.

- [#22](https://github.com/OllieJT/repp/pull/22) [`dff8c35`](https://github.com/OllieJT/repp/commit/dff8c3517e6e598e229f3f9b895f3b6b5397e959) Thanks [@OllieJT](https://github.com/OllieJT)! - Migrate from YAML to Markdown with frontmatter

  Plans now use `.md` files with YAML frontmatter instead of separate `.yml` files. Metadata and specification live in one file.

- [#22](https://github.com/OllieJT/repp/pull/22) [`dff8c35`](https://github.com/OllieJT/repp/commit/dff8c3517e6e598e229f3f9b895f3b6b5397e959) Thanks [@OllieJT](https://github.com/OllieJT)! - Remove tasks—plans are now the only entity

  Simplified data model by removing the separate task concept. Plans now serve both purposes, reducing complexity and cognitive overhead.

### Patch Changes

- [#22](https://github.com/OllieJT/repp/pull/22) [`dff8c35`](https://github.com/OllieJT/repp/commit/dff8c3517e6e598e229f3f9b895f3b6b5397e959) Thanks [@OllieJT](https://github.com/OllieJT)! - Move config to `plans/settings.json`

  Settings now live alongside plans in `plans/settings.json` instead of `.repprc` at repo root. Added graceful handling for invalid plan frontmatter.

- [#22](https://github.com/OllieJT/repp/pull/22) [`dff8c35`](https://github.com/OllieJT/repp/commit/dff8c3517e6e598e229f3f9b895f3b6b5397e959) Thanks [@OllieJT](https://github.com/OllieJT)! - Adds `config show` command to show the resolved settings being used by the CLI.

- [#22](https://github.com/OllieJT/repp/pull/22) [`dff8c35`](https://github.com/OllieJT/repp/commit/dff8c3517e6e598e229f3f9b895f3b6b5397e959) Thanks [@OllieJT](https://github.com/OllieJT)! - Adds claude skill + subagent config

## 0.1.0

### Minor Changes

- [#15](https://github.com/OllieJT/repp/pull/15) [`1e9ccbd`](https://github.com/OllieJT/repp/commit/1e9ccbdff1ab278e9d3bb1a9708d25edf3a76e23) Thanks [@OllieJT](https://github.com/OllieJT)! - Add task mutation commands: prioritize, review, complete, note

- [#17](https://github.com/OllieJT/repp/pull/17) [`28f3b08`](https://github.com/OllieJT/repp/commit/28f3b08cd76e6ac228ff568aec03b0d85327fcc7) Thanks [@OllieJT](https://github.com/OllieJT)! - Replace `--min-priority` with `--priority` for exact matching. Accept comma-separated values (e.g., `--priority=1,2,3`) and support any alphanumeric priority format (1, 01, P1, high, etc.).

## 0.0.2

### Patch Changes

- [#13](https://github.com/OllieJT/repp/pull/13) [`ad443b3`](https://github.com/OllieJT/repp/commit/ad443b3fb66fa6bdf11140f4e2e2398e682e2d12) Thanks [@OllieJT](https://github.com/OllieJT)! - Fix package.json config for npm

## 0.0.1

### Patch Changes

- [#8](https://github.com/OllieJT/repp/pull/8) [`16b6e62`](https://github.com/OllieJT/repp/commit/16b6e62edb6b6095e675b90513f2d5615ac6f7aa) Thanks [@OllieJT](https://github.com/OllieJT)! - Fix usage of `npx repp`

- [#7](https://github.com/OllieJT/repp/pull/7) [`ead04be`](https://github.com/OllieJT/repp/commit/ead04be8a71da67198eb005ddf118587be8a1340) Thanks [@OllieJT](https://github.com/OllieJT)! - Initial Release

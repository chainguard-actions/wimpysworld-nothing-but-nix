<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v9

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v9** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ }} expressions are directly interpolated inside run: shell command strings in action.yml, violating rule (a). GitHub Actions performs YAML template substitution before the shell runs, so any special characters in these values can break out of the intended shell context.

- 'The Checks' step: `${{ runner.os }}` is interpolated directly in three `if [[ "${{ runner.os }}" == ... ]]` comparisons. While runner.os is GitHub-controlled, any ${{ }} in a run: block is a script-injection finding per the check rules.
- 'The Hatchet Protocol' step: `input_protocol="${{ inputs.hatchet-protocol }}"` — attacker-controlled input interpolated directly into a shell variable assignment.
- 'The Volume' step: `$((${{ inputs.mnt-safe-haven }} + 1024))` and `$((free_space - ${{ inputs.mnt-safe-haven }}))` — attacker-controlled input interpolated into arithmetic expressions; also `${{ inputs.nix-permission-edict }}` in an `if` comparison.
- 'The Purge' step: `${{ steps.set-hatchet-protocol.outputs.level }}`, `${{ inputs.root-safe-haven }}` interpolated into a heredoc script (the heredoc delimiter is quoted but ${{ }} is substituted by GitHub Actions before the shell sees it); and `${{ inputs.witness-carnage }}` in an `if` comparison.

All inputs.* values are attacker-controllable via the calling workflow.

Locations:

- `action.yml:35`
- `action.yml:42`
- `action.yml:49`
- `action.yml:76`
- `action.yml:118`
- `action.yml:125`
- `action.yml:136`
- `action.yml:175`
- `action.yml:176`
- `action.yml:258`

### unpinned-uses (severity: high)

Several `uses:` references are pinned to mutable tags or branch names rather than immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag or branch is moved or compromised.

In action.yml:
- `srz-zumix/post-run-action@v3` (tag)

In .github/workflows/test.yaml:
- `actions/checkout@v6` (tag)
- `DeterminateSystems/determinate-nix-action@main` (branch)
- `nixbuild/nix-quick-install-action@v34` (tag)
- `cachix/install-nix-action@v31` (tag)

In .github/workflows/debug.yaml:
- `actions/checkout@v6` (tag)

In .github/workflows/test-macos.yaml:
- `actions/checkout@v6` (tag)
- `DeterminateSystems/determinate-nix-action@main` (branch)

In .github/workflows/test-windows.yaml:
- `actions/checkout@v6` (tag)

Locations:

- `action.yml:271`
- `.github/workflows/test.yaml:22`
- `.github/workflows/test.yaml:36`
- `.github/workflows/test.yaml:57`
- `.github/workflows/test.yaml:75`
- `.github/workflows/test.yaml:79`
- `.github/workflows/debug.yaml:20`
- `.github/workflows/test-macos.yaml:14`
- `.github/workflows/test-macos.yaml:20`
- `.github/workflows/test-windows.yaml:14`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.hatchet-protocol }}" appears directly in run: block of step "The Hatchet Protocol"; move to env: map

Locations:

- `action.yml:83`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:143`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:157`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.nix-permission-edict }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:177`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.root-safe-haven }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.witness-carnage }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:388`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, unpinned-uses

**Notes:**

Fixed all script-injection findings in action.yml by moving every ${{ }} expression from run: blocks into step-level env: blocks and referencing them as plain environment variables. Fixed unpinned-uses by pinning all mutable tag/branch references to full 40-character commit SHAs in action.yml and all .github/workflows/*.yaml files. The heredoc in 'The Purge' step uses a quoted delimiter ('EOF') so GitHub Actions substitution doesn't occur inside it; the env vars (INPUT_PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN) are inherited by the child script via the process environment.


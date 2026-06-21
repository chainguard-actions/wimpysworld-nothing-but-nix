<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **wimpysworld--nothing-but-nix/v6** was hardened automatically. 7 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ }}` expressions are interpolated directly inside `run:` shell command strings, allowing shell metacharacter injection before the shell ever quotes the value.

**Step "The Checks"** (line ~33): `if [[ "${{ runner.os }}" == "Linux" ]]; then` — `runner.*` context injected directly into shell.

**Step "The Hatchet Protocol"** (line ~62): `input_protocol="${{ inputs.hatchet-protocol }}"` — attacker-controlled `inputs.*` value injected directly into shell assignment.

**Step "The Volume"** (line ~100): `sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` — `inputs.mnt-safe-haven` injected into an arithmetic expression without quoting or sanitization.

**Step "The Volume"** (line ~108): `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]; then` — `inputs.*` injected directly into shell.

**Step "The Purge"** (line ~131, inside heredoc): `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` — `steps.*.outputs.*` injected into the heredoc script body.

**Step "The Purge"** (line ~133, inside heredoc): `root_safe_haven="${{ inputs.root-safe-haven }}"` — `inputs.*` injected into the heredoc script body.

**Step "The Purge"** (line ~209): `if [ "${{ inputs.witness-carnage }}" == "true" ]; then` — `inputs.*` injected directly into shell. All of these should be moved to `env:` variables and referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:33`
- `action.yml:62`
- `action.yml:100`
- `action.yml:108`
- `action.yml:131`
- `action.yml:133`
- `action.yml:209`

### unpinned-uses (severity: high)

The composite action step "The Post" references `srz-zumix/post-run-action@v2`, which uses a mutable version tag (`@v2`) instead of a pinned 40-character commit SHA. This means the action could be silently updated to a different (potentially malicious) version without any change to this file. It should be pinned to a full SHA, e.g. `srz-zumix/post-run-action@<40-char-sha> # v2`.

Locations:

- `action.yml:218`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.hatchet-protocol }}" appears directly in run: block of step "The Hatchet Protocol"; move to env: map

Locations:

- `action.yml:62`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:123`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.nix-permission-edict }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:137`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.root-safe-haven }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:168`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.witness-carnage }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:349`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, unpinned-uses

**Notes:**

Fixed all script-injection findings by moving ${{ }} expressions to env: blocks in each affected step: (1) 'The Checks': runner.os → RUNNER_OS env var; (2) 'The Hatchet Protocol': inputs.hatchet-protocol → INPUT_HATCHET_PROTOCOL env var; (3) 'The Volume': inputs.mnt-safe-haven → INPUT_MNT_SAFE_HAVEN and inputs.nix-permission-edict → INPUT_NIX_PERMISSION_EDICT env vars; (4) 'The Purge': steps.set-hatchet-protocol.outputs.level → INPUT_PROTOCOL_LEVEL, inputs.root-safe-haven → INPUT_ROOT_SAFE_HAVEN, inputs.witness-carnage → INPUT_WITNESS_CARNAGE env vars. The heredoc in 'The Purge' was kept as 'EOF' (quoted) to prevent shell expansion at write time — the env vars are available at runtime when the script executes. Fixed unpinned-uses by pinning srz-zumix/post-run-action@v2 to its full SHA @2bf288bc024acd0341914f792a811080ebd0f252 with # v2 comment.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the arithmetic injection vulnerability in 'The Volume' step of action.yml. The fix adds integer validation using a regex check (`^[0-9]+$`) on `$INPUT_MNT_SAFE_HAVEN` before it is used in the bash arithmetic expression. If the value is not a pure non-negative integer, the script exits with an error. The validated value is stored in a local variable `mnt_safe_haven` which is then referenced (without `$` prefix) inside the arithmetic expression `$((free_space - mnt_safe_haven))`, preventing array subscript injection attacks like `a[$(malicious_cmd)]`.


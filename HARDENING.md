<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v8

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **wimpysworld--nothing-but-nix/v8** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ }}` expressions are interpolated directly inside `run:` shell command strings (sub-rule a), allowing script injection. Any value substituted by the YAML templating engine before the shell executes can contain shell metacharacters.

**Step "The Checks"** (3 occurrences):
- `if [[ "${{ runner.os }}" == "macOS" ]]` — runner context injected directly into shell
- `if [[ "${{ runner.os }}" == "Windows" ]]`
- `if [[ "${{ runner.os }}" == "Linux" ]]`

**Step "The Hatchet Protocol"**:
- `input_protocol="${{ inputs.hatchet-protocol }}"` — caller-controlled input injected directly into shell

**Step "The Volume"** (3 occurrences):
- `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` — caller-controlled input in arithmetic context
- `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M ...` — same input again
- `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]` — caller-controlled input

**Step "The Purge"** (3 occurrences):
- `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` — step output injected directly
- `root_safe_haven="${{ inputs.root-safe-haven }}"` — caller-controlled input
- `if [ "${{ inputs.witness-carnage }}" == "true" ]` — caller-controlled input

All of these should be moved to `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`) inside the `run:` block.

Locations:

- `action.yml:34`
- `action.yml:42`
- `action.yml:51`
- `action.yml:79`
- `action.yml:108`
- `action.yml:121`
- `action.yml:131`
- `action.yml:145`
- `action.yml:147`
- `action.yml:222`

### unpinned-uses (severity: high)

The composite action references `srz-zumix/post-run-action@v3` using a mutable tag (`@v3`) rather than a pinned 40-character commit SHA. A tag can be moved by the repository owner (or a compromised account) to point to arbitrary malicious code, creating a supply-chain attack vector. It should be pinned to a full SHA, e.g. `srz-zumix/post-run-action@<40-char-sha> # v3`.

Locations:

- `action.yml:228`

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

Fixed all script injection findings by moving ${{ }} expressions into env: blocks and referencing them as plain shell variables. Specifically: (1) 'The Checks' step: RUNNER_OS env var replaces three runner.os injections; (2) 'The Hatchet Protocol' step: INPUT_HATCHET_PROTOCOL env var replaces inputs.hatchet-protocol injection; (3) 'The Volume' step: INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT env vars replace three injections; (4) 'The Purge' step: INPUT_PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, INPUT_WITNESS_CARNAGE env vars replace all injections — the heredoc is kept quoted ('EOF') to avoid expanding runtime shell variables, and the script reads EXPAND_PROTOCOL_LEVEL/EXPAND_ROOT_SAFE_HAVEN passed as env vars at invocation. Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6.


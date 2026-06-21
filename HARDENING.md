<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v9

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **wimpysworld--nothing-but-nix/v9** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ }} expressions are interpolated directly inside run: shell command strings, violating rule (a). This allows template substitution to inject arbitrary shell metacharacters before the shell ever parses the command.

- Line 35: `if [[ "${{ runner.os }}" == "macOS" ]]` — runner.os interpolated directly in shell
- Line 44: `if [[ "${{ runner.os }}" == "Windows" ]]` — runner.os interpolated directly in shell
- Line 52: `if [[ "${{ runner.os }}" == "Linux" ]]` — runner.os interpolated directly in shell
- Line 76: `input_protocol="${{ inputs.hatchet-protocol }}"` — attacker-controlled input interpolated directly
- Line 108: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` — attacker-controlled input interpolated directly in arithmetic
- Line 116: `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` — attacker-controlled input interpolated directly in arithmetic
- Line 131: `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]` — attacker-controlled input interpolated directly
- Line 163: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` — step output interpolated directly inside heredoc
- Line 164: `root_safe_haven="${{ inputs.root-safe-haven }}"` — attacker-controlled input interpolated directly inside heredoc
- Line 237: `if [ "${{ inputs.witness-carnage }}" == "true" ]` — attacker-controlled input interpolated directly

All of these should be moved to env: variables and referenced as quoted shell variables (e.g., "$VAR") instead.

Locations:

- `action.yml:35`
- `action.yml:44`
- `action.yml:52`
- `action.yml:76`
- `action.yml:108`
- `action.yml:116`
- `action.yml:131`
- `action.yml:163`
- `action.yml:164`
- `action.yml:237`

### unpinned-uses (severity: high)

The composite action step 'The Post' references `srz-zumix/post-run-action@v3`, which uses a mutable version tag rather than a pinned 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit at any time, creating a supply-chain risk. It should be pinned to a full SHA, e.g. `srz-zumix/post-run-action@<40-char-sha> # v3`.

Locations:

- `action.yml:272`

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

**Fixes applied:** script-injection, unpinned-uses, static-inline-injection

**Notes:**

Fixed all script injection issues by moving ${{ }} expressions to env: blocks in each affected step: (1) 'The Checks' step: added env: RUNNER_OS: ${{ runner.os }} and replaced all runner.os interpolations with $RUNNER_OS; (2) 'The Hatchet Protocol' step: added env: INPUT_HATCHET_PROTOCOL: ${{ inputs.hatchet-protocol }} and replaced the interpolation; (3) 'The Volume' step: added env: block with INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT, replaced all interpolations; (4) 'The Purge' step: added env: block with PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, INPUT_WITNESS_CARNAGE, replaced all interpolations including those inside the heredoc (which uses 'EOF' so vars expand at script runtime) and the witness-carnage check. Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6 with # v3 comment.


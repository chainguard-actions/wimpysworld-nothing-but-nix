<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v9

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v9** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings (rule a), allowing script injection. Any calling workflow can supply attacker-controlled values for inputs.* and steps.*.outputs.*, and runner.* values still flow through YAML template substitution before the shell sees them.

Offending lines:
- Line 35: `if [[ "${{ runner.os }}" == "macOS" ]];` (The Checks step)
- Line 43: `if [[ "${{ runner.os }}" == "Windows" ]];` (The Checks step)
- Line 51: `if [[ "${{ runner.os }}" == "Linux" ]];` (The Checks step)
- Line 77: `input_protocol="${{ inputs.hatchet-protocol }}"` (The Hatchet Protocol step)
- Line 107: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` (The Volume step)
- Line 116: `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` (The Volume step)
- Line 130: `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]];` (The Volume step)
- Line 155: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` (The Purge step, inside heredoc)
- Line 157: `root_safe_haven="${{ inputs.root-safe-haven }}"` (The Purge step, inside heredoc)
- Line 218: `if [ "${{ inputs.witness-carnage }}" == "true" ];` (The Purge step)

Fix: move each value into an env: block and reference it as a quoted shell variable (e.g. `"$INPUT_HATCHET_PROTOCOL"`), never interpolate ${{ }} directly inside a run: script.

Locations:

- `action.yml:35`
- `action.yml:43`
- `action.yml:51`
- `action.yml:77`
- `action.yml:107`
- `action.yml:116`
- `action.yml:130`
- `action.yml:155`
- `action.yml:157`
- `action.yml:218`

### unpinned-uses (severity: high)

The composite action step 'The Post' references `srz-zumix/post-run-action@v3`, which uses a mutable version tag instead of a pinned 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit at any time, creating a supply-chain risk. Fix: pin to a full SHA, e.g. `srz-zumix/post-run-action@<40-hex-sha> # v3`.

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

Fixed all script-injection findings by moving ${{ }} expressions from run: blocks into env: blocks and referencing them as shell variables. Specifically: (1) runner.os moved to RUNNER_OS env var in 'The Checks' step; (2) inputs.hatchet-protocol moved to INPUT_HATCHET_PROTOCOL in 'The Hatchet Protocol' step; (3) inputs.mnt-safe-haven moved to INPUT_MNT_SAFE_HAVEN and inputs.nix-permission-edict moved to INPUT_NIX_PERMISSION_EDICT in 'The Volume' step; (4) steps.set-hatchet-protocol.outputs.level moved to HATCHET_PROTOCOL_LEVEL, inputs.root-safe-haven moved to INPUT_ROOT_SAFE_HAVEN, and inputs.witness-carnage moved to INPUT_WITNESS_CARNAGE in 'The Purge' step. The heredoc in 'The Purge' uses quoted 'EOF' so env vars are inherited at script runtime. Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6.


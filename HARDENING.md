<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **wimpysworld--nothing-but-nix/v10** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings in action.yml (sub-rule a). This allows an attacker who controls the calling workflow's inputs or context values to inject arbitrary shell commands.

- "The Checks" step: `if [[ "${{ runner.os }}" == "macOS" ]]` (and two more occurrences for Windows/Linux checks). Any `${{ ... }}` in a run: block is a script-injection risk regardless of context.
- "The Hatchet Protocol" step: `input_protocol="${{ inputs.hatchet-protocol }}"` — user-controlled input directly interpolated.
- "The Volume" step: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` and `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` and `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]` — user-controlled inputs directly interpolated.
- "The Purge" step: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ inputs.root-safe-haven }}"`, and `if [ "${{ inputs.witness-carnage }}" == "true" ]` — step outputs and user-controlled inputs directly interpolated inside the run: block (even inside a heredoc, GitHub Actions interpolates expressions before the shell runs).

Locations:

- `action.yml:35`
- `action.yml:42`
- `action.yml:50`
- `action.yml:75`
- `action.yml:103`
- `action.yml:113`
- `action.yml:124`
- `action.yml:160`
- `action.yml:162`
- `action.yml:214`

### unpinned-uses (severity: high)

The composite action step "The Post" references `srz-zumix/post-run-action@v3`, which uses a mutable version tag (`v3`) rather than a full 40-character immutable commit SHA. This means the action could be silently updated to a malicious version without any change to this file, creating a supply-chain attack vector.

Locations:

- `action.yml:220`

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

Fixed all script-injection findings by moving every ${{ ... }} expression from run: blocks into step-level env: blocks and referencing them as plain shell environment variables. Specifically: (1) 'The Checks' step: runner.os moved to RUNNER_OS env var; (2) 'The Hatchet Protocol' step: inputs.hatchet-protocol moved to INPUT_HATCHET_PROTOCOL env var; (3) 'The Volume' step: inputs.mnt-safe-haven and inputs.nix-permission-edict moved to INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT env vars; (4) 'The Purge' step: steps.set-hatchet-protocol.outputs.level, inputs.root-safe-haven, and inputs.witness-carnage moved to INPUT_PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, and INPUT_WITNESS_CARNAGE env vars. Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6 with # v3 comment.


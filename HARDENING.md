<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v6** was hardened automatically. 10 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'The Checks' step directly interpolates `${{ runner.os }}` inside a `run:` shell command string. Any `${{ ... }}` expression in a run block is a script-injection risk because YAML template substitution happens before the shell ever sees the value. Offending line: `if [[ "${{ runner.os }}" == "Linux" ]]; then`

Locations:

- `action.yml:33`

### script-injection (severity: high)

Sub-rule (a): The 'The Hatchet Protocol' step directly interpolates the attacker-controlled `${{ inputs.hatchet-protocol }}` into a shell variable assignment inside a `run:` block. An attacker can inject shell metacharacters via this input. Offending line: `input_protocol="${{ inputs.hatchet-protocol }}"`

Locations:

- `action.yml:60`

### script-injection (severity: high)

Sub-rule (a): The 'The Volume' step directly interpolates two attacker-controlled inputs inside `run:` shell commands: (1) `${{ inputs.mnt-safe-haven }}` is embedded inside an arithmetic expression `$((free_space - ${{ inputs.mnt-safe-haven }}))M` — a malicious value could break out of the arithmetic context; (2) `${{ inputs.nix-permission-edict }}` is used in a conditional. Both are direct template substitutions into shell code.

Locations:

- `action.yml:107`
- `action.yml:119`

### script-injection (severity: high)

Sub-rule (a): The 'The Purge' step directly interpolates multiple untrusted expressions into a heredoc that is written to a shell script and then executed: (1) `${{ steps.set-hatchet-protocol.outputs.level }}` (a step output, workflow-controllable); (2) `${{ inputs.root-safe-haven }}` (attacker-controlled input); (3) `${{ inputs.witness-carnage }}` (attacker-controlled input). All three are direct `${{ }}` interpolations inside a `run:` block.

Locations:

- `action.yml:143`
- `action.yml:145`
- `action.yml:222`

### unpinned-uses (severity: high)

The composite action step 'The Post' references `srz-zumix/post-run-action@v2`, which uses a mutable version tag (`@v2`) rather than a pinned 40-character commit SHA. This means the action could be silently updated to a malicious version without any change to this file.

Locations:

- `action.yml:231`

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

Fixed all script-injection findings by moving ${{ }} expressions from run: blocks into step-level env: blocks and referencing them as plain shell variables. Specifically: (1) The Checks: ${{ runner.os }} → RUNNER_OS env var; (2) The Hatchet Protocol: ${{ inputs.hatchet-protocol }} → INPUT_HATCHET_PROTOCOL env var; (3) The Volume: ${{ inputs.mnt-safe-haven }} → INPUT_MNT_SAFE_HAVEN and ${{ inputs.nix-permission-edict }} → INPUT_NIX_PERMISSION_EDICT; (4) The Purge: ${{ steps.set-hatchet-protocol.outputs.level }} → PROTOCOL_LEVEL, ${{ inputs.root-safe-haven }} → INPUT_ROOT_SAFE_HAVEN, ${{ inputs.witness-carnage }} → INPUT_WITNESS_CARNAGE. The heredoc in The Purge uses a quoted 'EOF' delimiter so the env vars are inherited by the spawned script at runtime. Pinned srz-zumix/post-run-action@v2 to full SHA @2bf288bc024acd0341914f792a811080ebd0f252.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in 'The Volume' step of action.yml at line 108. Changed `$((free_space - $INPUT_MNT_SAFE_HAVEN))` to `$((free_space - "${INPUT_MNT_SAFE_HAVEN}"))` to double-quote the workflow-controllable input variable inside the arithmetic expression, preventing shell metacharacter injection.


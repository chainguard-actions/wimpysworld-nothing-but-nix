<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **wimpysworld--nothing-but-nix/v7** was hardened automatically. 11 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings in the 'The Checks' step. `${{ runner.os }}` is substituted directly into the shell script before the shell parses it, enabling script injection. Offending lines:
- `if [[ "${{ runner.os }}" == "macOS" ]]; then`
- `if [[ "${{ runner.os }}" == "Windows" ]]; then`
- `if [[ "${{ runner.os }}" == "Linux" ]]; then`
These should use the `$RUNNER_OS` environment variable instead.

Locations:

- `action.yml:35`
- `action.yml:43`
- `action.yml:52`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.hatchet-protocol }}` is directly interpolated inside a `run:` shell command string in the 'The Hatchet Protocol' step. Offending line:
- `input_protocol="${{ inputs.hatchet-protocol }}"`
This allows an attacker-controlled input to be injected into the shell script. The value should be passed via an `env:` block and the env var double-quoted.

Locations:

- `action.yml:83`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ inputs.* }}` expressions are directly interpolated inside `run:` shell command strings in the 'The Volume' step. Offending lines:
- `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))`
- `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M "/mnt/disk${loop_num}.img"; then`
- `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]; then`
These allow attacker-controlled inputs to be injected into shell arithmetic and conditionals. Values should be passed via `env:` blocks.

Locations:

- `action.yml:115`
- `action.yml:124`
- `action.yml:133`

### script-injection (severity: high)

Sub-rule (a): Multiple `${{ ... }}` expressions are directly interpolated inside a `run:` shell heredoc in the 'The Purge' step. Offending lines:
- `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`
- `root_safe_haven="${{ inputs.root-safe-haven }}"`
- `if [ "${{ inputs.witness-carnage }}" == "true" ]; then`
Even though `steps.set-hatchet-protocol.outputs.level` is a step output, it flows through YAML template substitution before the shell parses it. All three should be passed via `env:` blocks with double-quoted shell expansions.

Locations:

- `action.yml:163`
- `action.yml:165`
- `action.yml:228`

### unpinned-uses (severity: high)

The 'The Post' step uses `srz-zumix/post-run-action@v3`, which is pinned to a mutable tag (`@v3`) rather than an immutable full-length 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit at any time, enabling supply-chain attacks. It should be pinned to a specific commit SHA, e.g. `srz-zumix/post-run-action@<40-char-sha> # v3`.

Locations:

- `action.yml:237`

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

- `action.yml:174`

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

Fixed all script injection vulnerabilities by moving GitHub Actions template expressions out of run: shell strings and into env: blocks, then referencing them as plain environment variables in the shell scripts. Specifically: (1) The Checks: replaced ${{ runner.os }} with $RUNNER_OS (built-in env var); (2) The Hatchet Protocol: added env block for INPUT_HATCHET_PROTOCOL; (3) The Volume: added env block for INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT; (4) The Purge: added env block for INPUT_PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, and INPUT_WITNESS_CARNAGE - the heredoc uses single-quoted 'EOF' so the env vars are inherited by the generated script at runtime. Pinned srz-zumix/post-run-action@v3 to commit SHA 42756f7452b9439d0365b7e087b2c364f54209c6.


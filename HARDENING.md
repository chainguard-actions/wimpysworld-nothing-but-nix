<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v10** was hardened automatically. 8 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ }} expressions are directly interpolated inside run: shell blocks, allowing script injection. In the 'The Checks' step: `${{ runner.os }}` is used three times directly in shell conditionals. In 'The Hatchet Protocol': `input_protocol="${{ inputs.hatchet-protocol }}"` interpolates a user-controlled input directly into a shell variable assignment. In 'The Volume': `${{ inputs.mnt-safe-haven }}` is interpolated directly into arithmetic expressions and `${{ inputs.nix-permission-edict }}` into a conditional. In 'The Purge': `${{ steps.set-hatchet-protocol.outputs.level }}`, `${{ inputs.root-safe-haven }}`, and `${{ inputs.witness-carnage }}` are all interpolated directly into shell commands. Any of these values could contain shell metacharacters that execute arbitrary commands before the shell ever sees them.

Locations:

- `action.yml:34`
- `action.yml:43`
- `action.yml:52`
- `action.yml:80`
- `action.yml:119`
- `action.yml:131`
- `action.yml:148`
- `action.yml:175`
- `action.yml:177`
- `action.yml:247`

### unpinned-uses (severity: high)

The composite action step 'The Post' uses `srz-zumix/post-run-action@v3`, which is pinned to a mutable tag (`@v3`) rather than an immutable 40-character commit SHA. This means the action could be silently updated or compromised without any change to this file, enabling a supply-chain attack.

Locations:

- `action.yml:255`

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

Fixed all script injection findings by moving ${{ }} expressions to env: blocks in each affected step: 'The Checks' (runner.os → RUNNER_OS), 'The Hatchet Protocol' (inputs.hatchet-protocol → INPUT_HATCHET_PROTOCOL), 'The Volume' (inputs.mnt-safe-haven → INPUT_MNT_SAFE_HAVEN, inputs.nix-permission-edict → INPUT_NIX_PERMISSION_EDICT), 'The Purge' (steps.set-hatchet-protocol.outputs.level → INPUT_PROTOCOL_LEVEL, inputs.root-safe-haven → INPUT_ROOT_SAFE_HAVEN, inputs.witness-carnage → INPUT_WITNESS_CARNAGE). The heredoc script in 'The Purge' inherits these env vars from the parent shell environment. Also pinned srz-zumix/post-run-action@v3 to its immutable SHA @42756f7452b9439d0365b7e087b2c364f54209c6.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in 'The Volume' step of action.yml at lines 116 and 127. Added integer validation (`[[ "$INPUT_MNT_SAFE_HAVEN" =~ ^[0-9]+$ ]]`) before using the value in bash arithmetic expressions. The validated value is stored in a local variable `mnt_safe_haven` and used with double-quoting in both `$((...))` contexts: `min_required=$(("$mnt_safe_haven" + 1024))` and `sudo fallocate -l $(("$free_space" - "$mnt_safe_haven"))M`. This prevents arithmetic injection attacks where a crafted input like `a[$(malicious_command)]` could cause arbitrary command execution in bash.


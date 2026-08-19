<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v7** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell blocks in action.yml, violating rule (a). This allows template substitution to inject arbitrary shell metacharacters before the shell parses the command.

- 'The Checks' step: `if [[ "${{ runner.os }}" == "macOS" ]]` (and two more runner.os comparisons) — runner context values flow through YAML template substitution into the shell.
- 'The Hatchet Protocol' step: `input_protocol="${{ inputs.hatchet-protocol }}"` — user-controlled input directly interpolated.
- 'The Volume' step: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` and `sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` — arithmetic context does not prevent injection.
- 'The Volume' step: `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]` — user-controlled input directly interpolated.
- 'The Purge' step (heredoc): `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` and `root_safe_haven="${{ inputs.root-safe-haven }}"` — step outputs and inputs interpolated inside a heredoc that is written to a script file.
- 'The Purge' step: `if [ "${{ inputs.witness-carnage }}" == "true" ]` — user-controlled input directly interpolated.

All of these should be moved to env: variables and referenced as quoted shell variables (e.g., "$VAR") instead.

Locations:

- `action.yml:35`
- `action.yml:42`
- `action.yml:49`
- `action.yml:72`
- `action.yml:96`
- `action.yml:107`
- `action.yml:115`
- `action.yml:145`
- `action.yml:147`
- `action.yml:237`

### unpinned-uses (severity: high)

Several uses: references are pinned to mutable tags or branch names rather than immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag or branch is moved or compromised.

In action.yml:
- `uses: srz-zumix/post-run-action@v3` (tag, not a SHA)

In .github/workflows/debug.yaml:
- `uses: actions/checkout@v6` (tag, not a SHA)

In .github/workflows/test-macos.yaml:
- `uses: actions/checkout@v6` (tag, not a SHA)
- `uses: DeterminateSystems/determinate-nix-action@main` (branch, not a SHA)

In .github/workflows/test-windows.yaml:
- `uses: actions/checkout@v6` (tag, not a SHA)

In .github/workflows/test.yaml:
- `uses: actions/checkout@v6` (tag, not a SHA — appears in all three jobs)
- `uses: DeterminateSystems/determinate-nix-action@main` (branch, not a SHA)
- `uses: nixbuild/nix-quick-install-action@v34` (tag, not a SHA)
- `uses: cachix/install-nix-action@v31` (tag, not a SHA)

All should be pinned to full 40-character hex commit SHAs with the tag/version noted in a comment.

Locations:

- `action.yml:245`
- `.github/workflows/debug.yaml:21`
- `.github/workflows/test-macos.yaml:16`
- `.github/workflows/test-macos.yaml:21`
- `.github/workflows/test-windows.yaml:16`
- `.github/workflows/test.yaml:21`
- `.github/workflows/test.yaml:27`
- `.github/workflows/test.yaml:57`
- `.github/workflows/test.yaml:63`
- `.github/workflows/test.yaml:93`
- `.github/workflows/test.yaml:99`

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

Fixed all script injection issues in action.yml by moving ${{ }} expressions from run: blocks to env: blocks (RUNNER_OS, INPUT_PROTOCOL, MNT_SAFE_HAVEN, NIX_PERMISSION_EDICT, PROTOCOL_LEVEL, ROOT_SAFE_HAVEN, WITNESS_CARNAGE). The heredoc in The Purge step already uses single-quoted 'EOF' preventing template substitution; env vars are passed explicitly when the script executes. Pinned all unpinned action references to full 40-character commit SHAs: srz-zumix/post-run-action@42756f7452b9439d0365b7e087b2c364f54209c6 (v3), actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803 (v6), DeterminateSystems/determinate-nix-action@d96678350ffd6a456235832eb11e1c491589b7bb (main), nixbuild/nix-quick-install-action@2c9db80fb984ceb1bcaa77cdda3fdf8cfba92035 (v34), cachix/install-nix-action@630ae543ea3a38a9a4166f03376c02c50f408342 (v31).


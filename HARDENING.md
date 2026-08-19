<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v8

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v8** was hardened automatically. 8 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml, violating rule (a). This allows an attacker (or a calling workflow) to inject arbitrary shell commands.

- Line 35: `if [[ "${{ runner.os }}" == "macOS" ]]` — runner context interpolated directly in shell
- Line 41: `if [[ "${{ runner.os }}" == "Windows" ]]` — runner context interpolated directly in shell
- Line 47: `if [[ "${{ runner.os }}" == "Linux" ]]` — runner context interpolated directly in shell
- Line 76: `input_protocol="${{ inputs.hatchet-protocol }}"` — user-controlled input interpolated directly in shell
- Line 107: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` — user-controlled input interpolated directly in arithmetic
- Line 117: `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M` — user-controlled input interpolated directly in arithmetic/shell
- Line 128: `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]` — user-controlled input interpolated directly in shell
- Line 152: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` — step output interpolated directly in shell
- Line 153: `root_safe_haven="${{ inputs.root-safe-haven }}"` — user-controlled input interpolated directly in shell
- Line 220: `if [ "${{ inputs.witness-carnage }}" == "true" ]` — user-controlled input interpolated directly in shell

All of these should be moved to `env:` variables and referenced as `"$VAR"` in the shell script.

Locations:

- `action.yml:35`
- `action.yml:41`
- `action.yml:47`
- `action.yml:76`
- `action.yml:107`
- `action.yml:117`
- `action.yml:128`
- `action.yml:152`
- `action.yml:153`
- `action.yml:220`

### unpinned-uses (severity: high)

Several `uses:` references are pinned to mutable tags or branch names rather than immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag or branch is moved or compromised.

In action.yml:
- `srz-zumix/post-run-action@v3` (tag)

In .github/workflows/debug.yaml:
- `actions/checkout@v6` (tag)

In .github/workflows/test-macos.yaml:
- `actions/checkout@v6` (tag)
- `DeterminateSystems/determinate-nix-action@main` (branch)

In .github/workflows/test-windows.yaml:
- `actions/checkout@v6` (tag)

In .github/workflows/test.yaml:
- `actions/checkout@v6` (tag, appears 3 times)
- `DeterminateSystems/determinate-nix-action@main` (branch)
- `nixbuild/nix-quick-install-action@v34` (tag)
- `cachix/install-nix-action@v31` (tag)

All should be replaced with full 40-character SHA digests, e.g. `actions/checkout@<sha> # v6`.

Locations:

- `action.yml:228`
- `.github/workflows/debug.yaml:17`
- `.github/workflows/test-macos.yaml:15`
- `.github/workflows/test-macos.yaml:20`
- `.github/workflows/test-windows.yaml:15`
- `.github/workflows/test.yaml:20`
- `.github/workflows/test.yaml:28`
- `.github/workflows/test.yaml:47`
- `.github/workflows/test.yaml:62`
- `.github/workflows/test.yaml:80`

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

Fixed all script injection issues in action.yml by moving all ${{ }} expressions from run: blocks into env: blocks and referencing them as plain environment variables. Pinned all unpinned uses: references to full 40-character commit SHAs across action.yml and all .github/workflows/*.yaml files. Specifically: (1) The Checks step: runner.os → RUNNER_OS env var; (2) The Hatchet Protocol step: inputs.hatchet-protocol → INPUT_PROTOCOL env var; (3) The Volume step: inputs.mnt-safe-haven → INPUT_MNT_SAFE_HAVEN, inputs.nix-permission-edict → INPUT_NIX_PERMISSION_EDICT; (4) The Purge step: all 5 expressions moved to env: block. Pinned srz-zumix/post-run-action@v3 to SHA 42756f7452b9439d0365b7e087b2c364f54209c6, actions/checkout@v6 to df4cb1c069e1874edd31b4311f1884172cec0e10, DeterminateSystems/determinate-nix-action@main to 2a0be2498974c2b6327e19780488744384637d88, nixbuild/nix-quick-install-action@v34 to 2c9db80fb984ceb1bcaa77cdda3fdf8cfba92035, cachix/install-nix-action@v31 to 630ae543ea3a38a9a4166f03376c02c50f408342.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in action.yml:

1. 'The Volume' step: Added `if ! [[ "$INPUT_MNT_SAFE_HAVEN" =~ ^[0-9]+$ ]]` validation guard before arithmetic use. Assigned validated value to local variable `mnt_safe_haven` and replaced `$(($INPUT_MNT_SAFE_HAVEN + 1024))` and `$((free_space - $INPUT_MNT_SAFE_HAVEN))M` with `$(( mnt_safe_haven + 1024 ))` and `$(( free_space - mnt_safe_haven ))M` respectively.

2. 'The Purge' step heredoc: Added `if ! [[ "$root_safe_haven" =~ ^[0-9]+$ ]]` validation guard after the assignment from `INPUT_ROOT_SAFE_HAVEN`. Replaced `$((root_safe_haven + 2048))` and `$((free_space - root_safe_haven))` with `$(( root_safe_haven + 2048 ))` and `$(( free_space - root_safe_haven ))` respectively.

The integer validation prevents attackers from injecting array subscript expressions like `a[$(malicious_cmd)]` that would execute arbitrary commands inside bash arithmetic contexts.


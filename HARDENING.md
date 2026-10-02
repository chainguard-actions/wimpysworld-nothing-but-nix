<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v7** was hardened automatically. 11 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'The Checks' step directly interpolates `${{ runner.os }}` three times inside a `run:` shell command string. Although `runner.os` is GitHub-controlled, any `${{ ... }}` expression inside a `run:` block is a script-injection risk because YAML template substitution happens before the shell ever sees the value. The value is injected verbatim into the shell command without quoting at the template level. Offending lines: `if [[ "${{ runner.os }}" == "macOS" ]]`, `if [[ "${{ runner.os }}" == "Windows" ]]`, `if [[ "${{ runner.os }}" == "Linux" ]]`. Fix: use the `$RUNNER_OS` environment variable instead.

Locations:

- `action.yml:34`
- `action.yml:42`
- `action.yml:50`

### script-injection (severity: high)

Sub-rule (a): The 'The Hatchet Protocol' step directly interpolates `${{ inputs.hatchet-protocol }}` inside a `run:` shell command string: `input_protocol="${{ inputs.hatchet-protocol }}"`  This is attacker-controlled input injected directly into the shell before quoting. An attacker can supply a value containing shell metacharacters (e.g. `$(cmd)`, backticks) to achieve command injection. Fix: pass the input via an `env:` variable and reference it as `"$INPUT_HATCHET_PROTOCOL"`.

Locations:

- `action.yml:76`

### script-injection (severity: high)

Sub-rule (a): The 'The Volume' step directly interpolates `${{ inputs.mnt-safe-haven }}` (twice) and `${{ inputs.nix-permission-edict }}` inside `run:` shell command strings. Offending lines: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))`, `sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M ...`, and `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`. These are attacker-controlled inputs injected directly into arithmetic expressions and conditionals. Fix: pass inputs via `env:` variables and reference them as quoted shell variables.

Locations:

- `action.yml:117`
- `action.yml:127`
- `action.yml:137`

### script-injection (severity: high)

Sub-rule (a): The 'The Purge' step directly interpolates `${{ steps.set-hatchet-protocol.outputs.level }}`, `${{ inputs.root-safe-haven }}`, and `${{ inputs.witness-carnage }}` inside a `run:` shell command string (embedded in a heredoc that is written to a script file and then executed). Offending lines: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ inputs.root-safe-haven }}"`, and `if [ "${{ inputs.witness-carnage }}" == "true" ]`. Step outputs and inputs are workflow-controllable and must not be interpolated directly into shell. Fix: pass values via `env:` variables.

Locations:

- `action.yml:196`
- `action.yml:198`
- `action.yml:271`

### unpinned-uses (severity: high)

The 'The Post' step uses `srz-zumix/post-run-action@v3`, which is pinned to a mutable tag (`@v3`) rather than an immutable 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit at any time, enabling a supply-chain attack. Fix: pin to a full SHA, e.g. `srz-zumix/post-run-action@<40-hex-char-sha> # v3`.

Locations:

- `action.yml:281`

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

Fixed all script injection findings by moving ${{ }} expressions to env: blocks and referencing them as shell variables. Specifically: (1) 'The Checks' step: replaced ${{ runner.os }} with $RUNNER_OS (3 occurrences); (2) 'The Hatchet Protocol' step: added env: INPUT_HATCHET_PROTOCOL and replaced inline expression; (3) 'The Volume' step: added env: block with INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT; (4) 'The Purge' step: added env: block with PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, INPUT_WITNESS_CARNAGE, changed heredoc from quoted 'EOF' to unquoted EOF so env vars expand at write time, escaped all other $ signs inside the heredoc to preserve them as literals in the generated script; (5) Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in 'The Purge' step of action.yml. Changed the heredoc delimiter from unquoted `<< EOF` to quoted `<< 'EOF'` to prevent shell expansion at heredoc generation time. The variables PROTOCOL_LEVEL and INPUT_ROOT_SAFE_HAVEN (which were previously interpolated directly into the generated script text) are now read from the environment at script runtime — they're already set in the step's env: block so they're available as environment variables when /tmp/expand_nix_volume.sh executes. All the escape sequences (\$ -> $, \\ -> \) were cleaned up since they're no longer needed with a quoted heredoc. This eliminates the attack vector where an attacker controlling inputs.root-safe-haven could inject shell metacharacters that break out of the quoted assignment and execute arbitrary commands in the generated script.


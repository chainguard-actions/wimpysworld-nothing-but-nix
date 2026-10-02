<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v8

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v8** was hardened automatically. 12 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): `${{ runner.os }}` is interpolated directly inside a `run:` shell block three times in the 'The Checks' step. Any `${{ ... }}` expression inside a `run:` script is a script-injection risk because YAML template substitution happens before the shell parses the string. Offending lines: `if [[ "${{ runner.os }}" == "macOS" ]]`, `if [[ "${{ runner.os }}" == "Windows" ]]`, `if [[ "${{ runner.os }}" == "Linux" ]]`. These should be replaced with the safe env-var form `$RUNNER_OS`.

Locations:

- `action.yml:35`
- `action.yml:42`
- `action.yml:48`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.hatchet-protocol }}` is interpolated directly inside a `run:` shell block in the 'The Hatchet Protocol' step. Offending line: `input_protocol="${{ inputs.hatchet-protocol }}"`  — an attacker-controlled input value is substituted into the shell command string before the shell parses it, enabling shell metacharacter injection. Use an `env:` block and reference `"$INPUT_HATCHET_PROTOCOL"` instead.

Locations:

- `action.yml:80`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.mnt-safe-haven }}` is interpolated directly inside a `run:` shell block twice in the 'The Volume' step. Offending lines: `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` and `if sudo fallocate -l $((free_space - ${{ inputs.mnt-safe-haven }}))M ...`. Attacker-controlled input is substituted into arithmetic expressions in the shell command string before the shell parses it. Use an `env:` block and reference `"$INPUT_MNT_SAFE_HAVEN"` instead.

Locations:

- `action.yml:113`
- `action.yml:122`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.nix-permission-edict }}` is interpolated directly inside a `run:` shell block in the 'The Volume' step. Offending line: `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`. Attacker-controlled input is substituted into the shell command string before the shell parses it. Use an `env:` block and reference `"$INPUT_NIX_PERMISSION_EDICT"` instead.

Locations:

- `action.yml:133`

### script-injection (severity: high)

Sub-rule (a): `${{ steps.set-hatchet-protocol.outputs.level }}` and `${{ inputs.root-safe-haven }}` are interpolated directly inside a `run:` shell block in the 'The Purge' step (inside a heredoc written to /tmp/expand_nix_volume.sh). Offending lines: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"` and `root_safe_haven="${{ inputs.root-safe-haven }}"`  — these values are YAML-template-substituted before the shell executes, enabling injection into the generated script. Additionally, `${{ inputs.witness-carnage }}` is interpolated directly in the outer `run:` block: `if [ "${{ inputs.witness-carnage }}" == "true" ]`. Use `env:` blocks and reference safe env-var names instead.

Locations:

- `action.yml:155`
- `action.yml:157`
- `action.yml:207`

### unpinned-uses (severity: high)

The step 'The Post' uses `srz-zumix/post-run-action@v3`, which references a mutable tag (`v3`) rather than a full 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit at any time, enabling a supply-chain attack. Pin to a specific commit SHA, e.g. `srz-zumix/post-run-action@<40-char-sha> # v3`.

Locations:

- `action.yml:222`

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

Fixed all script injection findings by moving ${{ }} expressions to env: blocks and referencing them as environment variables: (1) The Checks: replaced ${{ runner.os }} with $RUNNER_OS (built-in env var, no env block needed); (2) The Hatchet Protocol: added env block with INPUT_HATCHET_PROTOCOL; (3) The Volume: added env block with INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT; (4) The Purge: added env block with PROTOCOL_LEVEL, INPUT_ROOT_SAFE_HAVEN, INPUT_WITNESS_CARNAGE - the heredoc values inside the quoted 'EOF' heredoc were also YAML-substituted before shell execution so they needed fixing too. Pinned srz-zumix/post-run-action@v3 to full SHA 42756f7452b9439d0365b7e087b2c364f54209c6.


<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v11

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v11** was hardened automatically. 13 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): step 'The Checks' puts a runner context expression directly in the run script, e.g. `if [[ "${{ runner.os }}" == "macOS" ]]; then`. The same pattern repeats for Windows and Linux. Use "$RUNNER_OS" instead.

Locations:

- `action.yml:35`
- `action.yml:44`
- `action.yml:53`

### script-injection (severity: high)

Sub-rule (a): step 'The Hatchet Protocol' puts an input directly in the run script: `input_protocol="${{ inputs.hatchet-protocol }}"`. Anyone calling the action can inject shell code through this input. Move it into an env: variable and expand it with double quotes.

Locations:

- `action.yml:83`

### script-injection (severity: high)

Sub-rule (a): step 'The Volume' puts inputs directly in the run script, unquoted in some places: `effective_safe_haven=${{ inputs.root-safe-haven }}`, `if [ "${{ inputs.mnt-safe-haven }}" -gt ...`, `effective_safe_haven=${{ inputs.mnt-safe-haven }}` and `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`. Route these through env: variables and expand them with double quotes.

Locations:

- `action.yml:145`
- `action.yml:146`
- `action.yml:190`

### script-injection (severity: high)

Sub-rule (a): step 'The Purge' substitutes expressions into the generated script before the shell runs (the quoted 'EOF' heredoc does not protect against ${{ }} substitution): `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ inputs.root-safe-haven }}"` and `mnt_safe_haven="${{ inputs.mnt-safe-haven }}"`. It also uses `if [ "${{ inputs.witness-carnage }}" == "true" ]` directly in the run script. Pass these through env: variables instead.

Locations:

- `action.yml:219`
- `action.yml:221`
- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.hatchet-protocol }}" appears directly in run: block of step "The Hatchet Protocol"; move to env: map

Locations:

- `action.yml:83`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.root-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:145`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:146`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:147`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:151`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.nix-permission-edict }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.root-safe-haven }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.witness-carnage }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:407`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed in action.yml. The Checks step now reads $RUNNER_OS instead of using the runner.os expression. The Hatchet Protocol step passes its input through INPUT_HATCHET_PROTOCOL. The Volume step passes its three inputs through INPUT_* env vars and quotes them everywhere. The Purge step passes the protocol level and both safe-haven values through NBN_* env vars, and the witness-carnage input through INPUT_WITNESS_CARNAGE. The generated script reads the NBN_* values from the environment it inherits; its heredoc is quoted, so the shell expands nothing while writing it. Some edit_file calls applied wrongly at first and broke the YAML structure (a misplaced shell: line and a broken Volume step header). I found this by re-reading the file and repaired it with targeted edits.


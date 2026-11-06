<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v12** was hardened automatically. 11 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): step 'The Checks' puts `${{ runner.os }}` straight into the run script, e.g. `if [[ "${{ runner.os }}" == "macOS" ]]; then` (also in the Windows and Linux checks). Use the "$RUNNER_OS" variable instead.

Locations:

- `action.yml:56`

### script-injection (severity: high)

Sub-rule (a): step 'The Hatchet Protocol' puts an input straight into the script: `input_protocol="${{ inputs.hatchet-protocol }}"`. Any user of the action can set this input, so a crafted value can run shell commands. Pass it through an env: variable and quote it.

Locations:

- `action.yml:139`

### script-injection (severity: high)

Sub-rule (a): step 'The Volume' puts expressions straight into the script, some without quotes: `effective_safe_haven=${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}`, `if [ "${{ inputs.mnt-safe-haven }}" -gt ...`, `effective_safe_haven=${{ inputs.mnt-safe-haven }}`, and `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`. The inputs mnt-safe-haven and nix-permission-edict are inserted with no checks.

Locations:

- `action.yml:290`

### script-injection (severity: high)

Sub-rule (a): step 'The Purge' (Linux) puts expressions straight into the script it generates and runs: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}"`, `mnt_safe_haven="${{ inputs.mnt-safe-haven }}"`, `echo "${{ steps.set-hatchet-protocol.outputs.name }}"`, and `if [ "${{ inputs.witness-carnage }}" == "true" ]`. Pass these through env: variables and quote them.

Locations:

- `action.yml:408`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.hatchet-protocol }}" appears directly in run: block of step "The Hatchet Protocol"; move to env: map

Locations:

- `action.yml:142`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:305`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:306`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:310`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.nix-permission-edict }}" appears directly in run: block of step "The Volume"; move to env: map

Locations:

- `action.yml:374`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mnt-safe-haven }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:421`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.witness-carnage }}" appears directly in run: block of step "The Purge"; move to env: map

Locations:

- `action.yml:811`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

The Checks: replaced ${{ runner.os }} with "${RUNNER_OS}" (4 places). The Hatchet Protocol: added the env var HATCHET_PROTOCOL. The Volume: added env vars ROOT_SAFE_HAVEN_RESOLVED, MNT_SAFE_HAVEN and NIX_PERMISSION_EDICT, and quoted them where they are used. The Purge (Linux): added env vars PROTOCOL_LEVEL, PROTOCOL_NAME, ROOT_SAFE_HAVEN_RESOLVED, MNT_SAFE_HAVEN and WITNESS_CARNAGE. The generated script is written from a quoted heredoc ('EOF'), so it reads these variables when it runs. It runs as a child process of the step in both foreground and background mode, so it inherits them.

### Iteration 2

**Fixes applied:** script-injection, invalid-yaml

**Notes:**

- **The Checks:** the four inline ${{ runner.os }} checks now read "${RUNNER_OS}".
- **The Hatchet Protocol:** fixed the merged 'shell:'/env line that made the YAML invalid at line 138. Restored 'shell: bash' and the env: block, and removed the stray text after input_protocol.
- **The Volume:** added MNT_SAFE_HAVEN, ROOT_SAFE_HAVEN_RESOLVED (from steps.set-hatchet-protocol.outputs.root-safe-haven) and NIX_PERMISSION_EDICT to env:. The broken nix-permission-edict line is back to a clean `if [[ "${NIX_PERMISSION_EDICT}" == "true" ]]; then` followed by an echo. I rewrote that echo's text, 'Granting user ownership of /nix', because the original line was cut off.
- **The Purge (Linux):** added PROTOCOL_LEVEL, PROTOCOL_NAME, ROOT_SAFE_HAVEN_RESOLVED, MNT_SAFE_HAVEN and WITNESS_CARNAGE to env:. The generated script reads these from its environment: step env vars are exported, and the script runs as a direct child process, not under sudo. The protocol file write and the witness-carnage check also use the env vars now.
- **Tool problem:** edit_file put text in the wrong place after lines with multi-byte emoji, which is likely what damaged the file before this pass. To avoid that, I rewrote the whole file with write_file instead of making targeted edits.


<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v12** was hardened automatically. 12 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): step 'The Checks' puts `${{ runner.os }}` straight into the run script, for example `if [[ "${{ runner.os }}" == "macOS" ]]; then`, and repeats it in the Windows and Linux checks. Use the $RUNNER_OS env var instead.

Locations:

- `action.yml:58`
- `action.yml:83`

### script-injection (severity: high)

Rule (a): step 'The Hatchet Protocol' puts a caller-supplied input straight into the run script: `input_protocol="${{ inputs.hatchet-protocol }}"`. A value such as `"; malicious; "` would run as shell code. Pass it in through env: and read it as "$HATCHET_PROTOCOL".

Locations:

- `action.yml:142`

### script-injection (severity: high)

Rule (a): step 'The Volume' puts several expressions straight into the run script: `effective_safe_haven=${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}`, `if [ "${{ inputs.mnt-safe-haven }}" -gt ...`, `effective_safe_haven=${{ inputs.mnt-safe-haven }}` (unquoted) and `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`. mnt-safe-haven and nix-permission-edict come from the caller and are never validated. Pass them in through env: and quote every expansion.

Locations:

- `action.yml:304`
- `action.yml:305`
- `action.yml:310`
- `action.yml:374`

### script-injection (severity: high)

Rule (a): step 'The Purge' (Linux) puts expressions into the generated script /tmp/expand_nix_volume.sh and into its own script: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}"`, `mnt_safe_haven="${{ inputs.mnt-safe-haven }}"`, `echo "${{ steps.set-hatchet-protocol.outputs.name }}" > ...` and `if [ "${{ inputs.witness-carnage }}" == "true" ]`. The heredoc is quoted ('EOF'), but the runner substitutes the expressions before the shell runs, so caller input such as mnt-safe-haven or witness-carnage reaches the shell unescaped. Pass these values in through env: and quote them.

Locations:

- `action.yml:409`
- `action.yml:418`
- `action.yml:421`

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index 00d7d23..b249aac 100644
--- a/action.yml
+++ b/action.yml
@@ -44,6 +44,23 @@ outputs:
 runs:
   using: composite
   steps:
     - name: The Checks
       id: environment-check
       shell: bash
@@ -55,7 +72,7 @@ runs:
       run: |
         # Check for macOS/Darwin. Apple silicon is supported. Intel runners
         # skip with a notice, and the workflow continues.
-        if [[ "${{ runner.os }}" == "macOS" ]]; then
+        if [[ "${RUNNER_OS}" == "macOS" ]]; then
           if [[ "$(uname -m)" != "arm64" ]]; then
             echo "is_supported=false" >> "${GITHUB_OUTPUT}"
             echo "⚠️  Nothing but Nix supports macOS on Apple silicon (arm64) only, and this runner is $(uname -m)."
@@ -80,7 +97,7 @@ runs:
         fi
 
         # Check for Windows - warn but don't fail
-        if [[ "${{ runner.os }}" == "Windows" ]]; then
+        if [[ "${RUNNER_OS}" == "Windows" ]]; then
           echo "is_supported=false" >> "${GITHUB_OUTPUT}"
           echo "⚠️  Nothing but Nix is designed for Ubuntu runners only."
           echo "ℹ️  Windows runners do not require this action - they have different filesystem layouts and constraints."
@@ -90,7 +107,7 @@ runs:
 
         # Check for loop device support - warn but don't fail. Container
         # runners such as ubuntu-slim have no loop devices and cannot mount.
-        if [[ "${{ runner.os }}" == "Linux" ]]; then
+        if [[ "${RUNNER_OS}" == "Linux" ]]; then
           loop_reason=""
           if [[ ! -e /dev/loop-control ]]; then
             loop_reason="/dev/loop-control does not exist"
@@ -107,7 +124,7 @@ runs:
         fi
 
         # Check for Ubuntu on Linux runners
-        if [[ "${{ runner.os }}" == "Linux" ]]; then
+        if [[ "${RUNNER_OS}" == "Linux" ]]; then
           if [ "$(lsb_release -is)" != "Ubuntu" ]; then
             echo "is_supported=false" >> "${GITHUB_OUTPUT}"
             echo "❌ This action only works on Ubuntu runners"
@@ -138,8 +155,9 @@ runs:
       shell: bash
       env:
         ROOT_SAFE_HAVEN: ${{ inputs.root-safe-haven }}
+        HATCHET_PROTOCOL: ${{ inputs.hatchet-protocol }}
       run: |
-        input_protocol="${{ inputs.hatchet-protocol }}"
+        input_protocol="${HATCHET_PROTOCOL}"
         # Convert to lowercase for case-insensitive comparison
         input_protocol="$(tr '[:upper:]' '[:lower:]' <<< "$input_protocol")"
 
@@ -276,6 +294,9 @@ runs:
       shell: bash
       env:
         BTRFS_COMPRESSION: ${{ inputs.btrfs-compression }}
+        MNT_SAFE_HAVEN: ${{ inputs.mnt-safe-haven }}
+        ROOT_SAFE_HAVEN_RESOLVED: ${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}
+        NIX_PERMISSION_EDICT: ${{ inputs.nix-permission-edict }}
       run: |
         # Check the compression before anything changes on disk
         compression="${BTRFS_COMPRESSION}"
@@ -301,13 +322,13 @@ runs:
         root_fs_dev=$(df -P / | awk 'NR==2 {print $1}')
         mnt_fs_dev=$(df -P /mnt | awk 'NR==2 {print $1}')
         if [ "${root_fs_dev}" = "${mnt_fs_dev}" ]; then
-          effective_safe_haven=${{ steps.set-hatchet-protocol.outputs.root-safe-haven }}
-          if [ "${{ inputs.mnt-safe-haven }}" -gt "${effective_safe_haven}" ]; then
-            effective_safe_haven=${{ inputs.mnt-safe-haven }}
+          effective_safe_haven="${ROOT_SAFE_HAVEN_RESOLVED}"
+          if [ "${MNT_SAFE_HAVEN}" -gt "${effective_safe_haven}" ]; then
+            effective_safe_haven="${MNT_SAFE_HAVEN}"
           fi
           echo "ℹ️  / and /mnt share filesystem ${root_fs_dev}; reserving ${effective_safe_haven}MB safe haven"
         else
-          effective_safe_haven=${{ inputs.mnt-safe-haven }}
+          effective_safe_haven="${MNT_SAFE_HAVEN}"
         fi
 
         # Minimum usable space: safe haven + 1024MB for a useful initial volume
@@ -371,8 +392,8 @@ runs:
         # Create /nix/build for Nix's build-dir setting
         sudo mkdir -p /nix/build
 
-        if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]; then
-          echo "Applying Nix Permiss
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, prior-fix

**Notes:**

Fixed action.yml by moving every ${{ }} expression out of the run: scripts. In 'The Checks', ${{ runner.os }} is now $RUNNER_OS. In 'The Hatchet Protocol', hatchet-protocol comes in through env as HATCHET_PROTOCOL. In 'The Volume', mnt-safe-haven, the resolved root-safe-haven and nix-permission-edict come in through env, and every expansion is quoted. In the Linux 'The Purge', the protocol level, name, resolved root-safe-haven, mnt-safe-haven and witness-carnage come in through env. The generated /tmp/expand_nix_volume.sh is still written with a quoted 'EOF' heredoc, so its ${...} references stay as text and are filled in from the inherited environment when the script runs, including when it runs in the background. This re-applies the previous harden's changes. Not run or tested.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Added a check that inputs.mnt-safe-haven matches ^[0-9]+$ in two places in action.yml. The first is 'The Volume' step, after the btrfs-compression check and before any arithmetic or -gt comparison. The second is the generated expand_nix_volume.sh script in 'The Purge' step (written via a quoted heredoc), before the safe haven is used in arithmetic. In both places the resolved root safe haven also gets the same check as a precaution. An invalid value now fails the step with a ::error:: message. Valid numeric values behave exactly as before. I didn't run the action after the change.


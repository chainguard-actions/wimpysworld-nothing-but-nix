<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v11

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v11** was hardened automatically. 14 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) violation in step 'The Checks': the script puts ${{ runner.os }} straight into the shell, e.g. `if [[ "${{ runner.os }}" == "macOS" ]]; then` (also on the Windows and Linux checks). Use $RUNNER_OS instead.

Locations:

- `action.yml:35`
- `action.yml:44`
- `action.yml:53`

### script-injection (severity: high)

Rule (a) violation in step 'The Hatchet Protocol': `input_protocol="${{ inputs.hatchet-protocol }}"` puts the input straight into the shell script. Pass it through an env: variable and quote it.

Locations:

- `action.yml:83`

### script-injection (severity: high)

Rule (a) violation in step 'The Volume': the script puts inputs straight into the shell, and some of them unquoted: `effective_safe_haven=${{ inputs.root-safe-haven }}`, `if [ "${{ inputs.mnt-safe-haven }}" -gt ...`, `effective_safe_haven=${{ inputs.mnt-safe-haven }}`, `if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`.

Locations:

- `action.yml:145`
- `action.yml:146`
- `action.yml:151`
- `action.yml:190`

### script-injection (severity: high)

Rule (a) violation in step 'The Purge': expressions are expanded into the generated script: `protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ inputs.root-safe-haven }}"`, `mnt_safe_haven="${{ inputs.mnt-safe-haven }}"`, and `if [ "${{ inputs.witness-carnage }}" == "true" ]`.

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index f58f8a8..cdcbbd4 100644
--- a/action.yml
+++ b/action.yml
@@ -27,12 +27,29 @@ inputs:
 runs:
   using: composite
   steps:
     - name: The Checks
       id: environment-check
       shell: bash
       run: |
         # Check for macOS/Darwin - warn but don't fail
-        if [[ "${{ runner.os }}" == "macOS" ]]; then
+        if [[ "$RUNNER_OS" == "macOS" ]]; then
           echo "is_supported=false" >> $GITHUB_OUTPUT
           echo "⚠️  Nothing but Nix is designed for Ubuntu runners only."
           echo "ℹ️  macOS/Darwin runners do not require this action - they already provide sufficient space for Nix."
@@ -41,7 +58,7 @@ runs:
         fi
 
         # Check for Windows - warn but don't fail
-        if [[ "${{ runner.os }}" == "Windows" ]]; then
+        if [[ "$RUNNER_OS" == "Windows" ]]; then
           echo "is_supported=false" >> $GITHUB_OUTPUT
           echo "⚠️  Nothing but Nix is designed for Ubuntu runners only."
           echo "ℹ️  Windows runners do not require this action - they have different filesystem layouts and constraints."
@@ -50,7 +67,7 @@ runs:
         fi
 
         # Check for Ubuntu on Linux runners
-        if [[ "${{ runner.os }}" == "Linux" ]]; then
+        if [[ "$RUNNER_OS" == "Linux" ]]; then
           if [ "$(lsb_release -is)" != "Ubuntu" ]; then
             echo "is_supported=false" >> $GITHUB_OUTPUT
             echo "❌ This action only works on Ubuntu runners"
@@ -79,8 +96,10 @@ runs:
       id: set-hatchet-protocol
       if: steps.environment-check.outputs.is_supported == 'true'
       shell: bash
+      env:
+        INPUT_HATCHET_PROTOCOL: ${{ inputs.hatchet-protocol }}
       run: |
-        input_protocol="${{ inputs.hatchet-protocol }}"
+        input_protocol="$INPUT_HATCHET_PROTOCOL"
         # Convert to lowercase for case-insensitive comparison
         input_protocol="$(tr '[:upper:]' '[:lower:]' <<< "$input_protocol")"
 
@@ -135,6 +154,10 @@ runs:
     - name: The Volume
       if: steps.environment-check.outputs.is_supported == 'true'
       shell: bash
+      env:
+        INPUT_ROOT_SAFE_HAVEN: ${{ inputs.root-safe-haven }}
+        INPUT_MNT_SAFE_HAVEN: ${{ inputs.mnt-safe-haven }}
+        INPUT_NIX_PERMISSION_EDICT: ${{ inputs.nix-permission-edict }}
       run: |
         free_space=$(df -m --output=avail /mnt | tail -n 1 | tr -d ' ')
         echo "Initial free space of /mnt: ${free_space}MB"
@@ -142,13 +165,13 @@ runs:
         root_fs_dev=$(df -P / | awk 'NR==2 {print $1}')
         mnt_fs_dev=$(df -P /mnt | awk 'NR==2 {print $1}')
         if [ "${root_fs_dev}" = "${mnt_fs_dev}" ]; then
-          effective_safe_haven=${{ inputs.root-safe-haven }}
-          if [ "${{ inputs.mnt-safe-haven }}" -gt "${effective_safe_haven}" ]; then
-            effective_safe_haven=${{ inputs.mnt-safe-haven }}
+          effective_safe_haven="$INPUT_ROOT_SAFE_HAVEN"
+          if [ "$INPUT_MNT_SAFE_HAVEN" -gt "${effective_safe_haven}" ]; then
+            effective_safe_haven="$INPUT_MNT_SAFE_HAVEN"
           fi
           echo "ℹ️  / and /mnt share filesystem ${root_fs_dev}; reserving ${effective_safe_haven}MB safe haven"
         else
-          effective_safe_haven=${{ inputs.mnt-safe-haven }}
+          effective_safe_haven="$INPUT_MNT_SAFE_HAVEN"
         fi
 
         # Minimum usable space: safe haven + 1024MB for a useful initial volume
@@ -187,7 +210,7 @@ runs:
         sudo mkdir -p /nix/build
         sudo mkdir -p /nix/tmp && sudo chmod 1777 /nix/tmp
 
-        if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]; then
+        if [[ "$INPUT_NIX_PERMISSION_EDICT" == "true" ]]; then
           echo "Applying Nix Permission Edict: Granting user ownership of /nix"
           sudo chown -R "$(id --user)":"$(id --group)" /nix
         fi
@@ -211,15 +234,20 @@ runs:
     - name: The Purge
       if: steps.environment-check.outputs.is_supported == 'true'
       shell: bash
+      env:
+        NBN_PROTOCOL_LEVEL: ${{ steps.set-hatchet-protocol.outputs.level }}
+        NBN_ROOT_SAFE_HAVEN: ${{ inputs
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, prior-fix

**Notes:**

action.yml: 'The Checks' now uses $RUNNER_OS. 'The Hatchet Protocol' reads INPUT_HATCHET_PROTOCOL from env. 'The Volume' reads INPUT_ROOT_SAFE_HAVEN, INPUT_MNT_SAFE_HAVEN and INPUT_NIX_PERMISSION_EDICT from env, and every use is now quoted. 'The Purge' passes the protocol level, both safe havens and witness-carnage through NBN_* env vars. The script it generates is written with a quoted heredoc ('EOF'), so the $NBN_* references are expanded only when the script runs. The script inherits the step's env, including when it runs in the background. No other behavior changed.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed both script-injection findings in action.yml. Not tested; edits only.

'The Volume' step: INPUT_ROOT_SAFE_HAVEN and INPUT_MNT_SAFE_HAVEN must now match ^[0-9]+$ before any arithmetic or comparison. The step stops with an error if either doesn't. Also quoted ${loop_dev}.

'The Purge' step: the generated script checks that root_safe_haven, mnt_safe_haven and protocol_level are integers before using them. The protocol_level check wasn't in the finding; I added it because that value also feeds numeric comparisons. Every '> $expansion_dir/...' write is now '> "$expansion_dir"/...'. The tee and redirect targets are now "${HOME}/.expansion/expansion.log". Also quoted free_space and loop_dev.

Post-run step: changed the ls to "${HOME}/.expansion/"*_done, so HOME is quoted and the glob still works.


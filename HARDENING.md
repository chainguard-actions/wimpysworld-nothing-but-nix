<!-- markdownlint-disable -->

# Hardening Report: wimpysworld--nothing-but-nix/v10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **wimpysworld--nothing-but-nix/v10** was hardened automatically. 12 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): step 'The Checks' puts `${{ runner.os }}` straight into the run script, e.g. `if [[ "${{ runner.os }}" == "macOS" ]]; then` (also used for the Windows and Linux checks). Use `$RUNNER_OS` instead.

Locations:

- `action.yml:35`

### script-injection (severity: high)

Rule (a): step 'The Hatchet Protocol' puts `${{ inputs.hatchet-protocol }}` straight into the run script: `input_protocol="${{ inputs.hatchet-protocol }}"`. A crafted input could break out of the quotes and run commands. Pass it through an env: variable instead.

Locations:

- `action.yml:83`

### script-injection (severity: high)

Rule (a): step 'The Volume' puts `${{ inputs.mnt-safe-haven }}` (in `min_required=$((${{ inputs.mnt-safe-haven }} + 1024))` and in the fallocate size) and `${{ inputs.nix-permission-edict }}` (`if [[ "${{ inputs.nix-permission-edict }}" == "true" ]]`) straight into the run script. Pass them through env: variables and quote them.

Locations:

- `action.yml:143`

### script-injection (severity: high)

Rule (a): step 'The Purge' puts `${{ steps.set-hatchet-protocol.outputs.level }}` and `${{ inputs.root-safe-haven }}` into the generated script (`protocol_level="${{ steps.set-hatchet-protocol.outputs.level }}"`, `root_safe_haven="${{ inputs.root-safe-haven }}"`), and `${{ inputs.witness-carnage }}` into the run script (`if [ "${{ inputs.witness-carnage }}" == "true" ]`). The quoted heredoc stops the shell from expanding anything inside it, but the runner substitutes these expressions into the text before any shell runs, so the generated script still contains the raw values. Pass them through env: variables instead.

Locations:

- `action.yml:201`

### unpinned-uses (severity: high)

Composite step 'The Post' uses a tag instead of a full 40-character commit SHA: `uses: srz-zumix/post-run-action@v3`.

Locations:

- `action.yml:384`

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yml b/action.yml
index 8594237..69e0a6a 100644
--- a/action.yml
+++ b/action.yml
@@ -1,5 +1,5 @@
 name: 'Nothing but Nix'
-description: 'Removes all the cruft 🪓 from a GitHub Actions runner to make the most space possible for Nix ️❄️'
+description: "Removes all the cruft \U0001FA93 from a GitHub Actions runner to make the most space possible for Nix ️❄️"
 branding:
   icon: 'trash-2'
   color: 'red'
@@ -27,12 +27,31 @@ inputs:
 runs:
   using: composite
   steps:
     - name: The Checks
       id: environment-check
       shell: bash
+      env:
+        RUNNER_OS: ${{ runner.os }}
       run: |
         # Check for macOS/Darwin - warn but don't fail
-        if [[ "${{ runner.os }}" == "macOS" ]]; then
+        if [[ "$RUNNER_OS" == "macOS" ]]; then
           echo "is_supported=false" >> $GITHUB_OUTPUT
           echo "⚠️  Nothing but Nix is designed for Ubuntu runners only."
           echo "ℹ️  macOS/Darwin runners do not require this action - they already provide sufficient space for Nix."
@@ -41,7 +60,7 @@ runs:
         fi
 
         # Check for Windows - warn but don't fail
-        if [[ "${{ runner.os }}" == "Windows" ]]; then
+        if [[ "$RUNNER_OS" == "Windows" ]]; then
           echo "is_supported=false" >> $GITHUB_OUTPUT
           echo "⚠️  Nothing but Nix is designed for Ubuntu runners only."
           echo "ℹ️  Windows runners do not require this action - they have different filesystem layouts and constraints."
@@ -50,7 +69,7 @@ runs:
         fi
 
         # Check for Ubuntu on Linux runners
-        if [[ "${{ runner.os }}" == "Linux" ]]; then
+        if [[ "$RUNNER_OS" == "Linux" ]]; then
           if [ "$(lsb_release -is)" != "Ubuntu" ]; then
             echo "is_supported=false" >> $GITHUB_OUTPUT
             echo "❌ This action only works on Ubuntu runners"
@@ -79,30 +98,9 @@ runs:
       id: set-hatchet-protocol
       if: steps.environment-check.outputs.is_supported == 'true'
       shell: bash
-      run: |
-        input_protocol="${{ inputs.hatchet-protocol }}"
-        # Convert to lowercase for case-insensitive comparison
-        input_protocol="$(tr '[:upper:]' '[:lower:]' <<< "$input_protocol")"
-
-        case "$input_protocol" in
-          "holster")
-            echo "🪓 Hatchet Protocol: Holster - Keep the hatchet sheathed, use space from /mnt (Level 0)"
-            protocol_level=0;;
-          "carve")
-            echo "🪓 Hatchet Protocol: Carve - Craft and combine free space from / and /mnt (Level 1)"
-            protocol_level=1;;
-          "cleave")
-            echo "🪓 Hatchet Protocol: Cleave - Make powerful, decisive cuts to large packages (Level 2)"
-            protocol_level=2;;
-          "rampage")
-            echo "🪓 Hatchet Protocol: Rampage - Relentless, brutal elimination of all bloat (Level 3)"
-            protocol_level=3;;
-          *)
-            echo "🪓 Hatchet Protocol: Cleave - Make powerful, decisive cuts to large packages (Level 2)"
-            protocol_level=2;;
-        esac
-
-        echo "level=${protocol_level}" >> $GITHUB_OUTPUT
+      env:
+        INPUT_HATCHET_PROTOCOL: ${{ inputs.hatchet-protocol }}
+      run: "input_protocol=\"$INPUT_HATCHET_PROTOCOL\"\n# Convert to lowercase for case-insensitive comparison\ninput_protocol=\"$(tr '[:upper:]' '[:lower:]' <<< \"$input_protocol\")\"\n\ncase \"$input_protocol\" in\n  \"holster\")\n    echo \"\U0001FA93 Hatchet Protocol: Holster - Keep the hatchet sheathed, use space from /mnt (Level 0)\"\n    protocol_level=0;;\n  \"carve\")\n    echo \"\U0001FA93 Hatchet Protocol: Carve - Craft and combine free space from / and /mnt (Level 1)\"\n    protocol_level=1;;\n  \"cleave\")\n    echo \"\U0001FA93 Hatchet Protocol: Cleave - Make powerful, decisive cuts to large packages (Level 2)\"\n    protocol_level=2;;\n  \"rampage\")\n    echo \"\U0001FA93 Hatchet Protocol: Rampage - Relentless, brutal elimination of all bloat (Level 3)\"\n    protocol_level=3;;\n  *)\n    echo \"\U0001FA93 Hatchet Protocol: Cleave - Make powerful, deci
... (truncated)
```

Locations:

- `action.yml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, unpinned-uses, prior-fix

**Notes:**

Changes to action.yml:
- The Checks: runner.os is now passed in through env as RUNNER_OS, and the three checks use "$RUNNER_OS".
- The Hatchet Protocol: inputs.hatchet-protocol is now passed in through env as INPUT_HATCHET_PROTOCOL.
- The Volume: mnt-safe-haven and nix-permission-edict are now passed in through env. mnt-safe-haven must be a non-negative integer, otherwise the step fails. Before, any text was dropped straight into the size calculation, which could run commands. Upstream failed on most bad values anyway, so this mainly changes when it fails.
- The Purge: the protocol level, root-safe-haven and witness-carnage are now passed in through env. The generated script (written with a quoted heredoc) reads $PROTOCOL_LEVEL and $INPUT_ROOT_SAFE_HAVEN from the environment it inherits. This works in both the foreground and background modes.
- The Purge also requires root-safe-haven to be a non-negative integer, for the same reason as mnt-safe-haven. This changes behaviour for a bad value. Upstream ran the whole purge and failed only when it got to the size calculation. Now the script stops before purging anything. In background mode the error goes only to the expansion log, not the step output.
- srz-zumix/post-run-action is pinned to 42756f7452b9439d0365b7e087b2c364f54209c6 (# v3).
- The prior-fix finding is covered by these same changes.


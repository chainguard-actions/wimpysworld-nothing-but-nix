#!/bin/sh
# Mock df: returns large available space values for /mnt and / so the action's
# space checks pass in Docker containers. For other calls, passes through to real df.
#
# The action checks:
#   df -m --output=avail /mnt  -> needs >= mnt-safe-haven + 1024 (default: 2048)
#   df -m --output=avail /     -> needs > root-safe-haven + 2048 (default: 4096)

# Check if this is a space-check call (--output=avail)
case "$*" in
  *--output=avail*/mnt*)
    # Return 51200 MB (50 GB) available on /mnt
    printf 'Avail\n51200\n'
    exit 0
    ;;
  *--output=avail*/*)
    # Return 51200 MB (50 GB) available on /
    printf 'Avail\n51200\n'
    exit 0
    ;;
  *)
    # Pass through to real df for display calls (df -h, etc.)
    exec /bin/df "$@"
    ;;
esac

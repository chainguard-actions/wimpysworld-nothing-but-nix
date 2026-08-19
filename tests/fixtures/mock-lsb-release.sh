#!/bin/sh
# Mock lsb_release: always reports Ubuntu so the action's environment check passes.
# The action checks: lsb_release -is == "Ubuntu"
case "$*" in
  *-is*) echo "Ubuntu" ;;
  *-cs*) echo "jammy" ;;
  *-rs*) echo "22.04" ;;
  *-ds*) echo "Ubuntu 22.04.3 LTS" ;;
  *-a*|*--all*)
    echo "No LSB modules are available."
    echo "Distributor ID:	Ubuntu"
    echo "Description:	Ubuntu 22.04.3 LTS"
    echo "Release:	22.04"
    echo "Codename:	jammy"
    ;;
  *) echo "Ubuntu" ;;
esac
exit 0

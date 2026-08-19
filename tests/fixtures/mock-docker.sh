#!/bin/sh
# Mock docker: returns empty results for image listing and exits 0 for other operations.
# This prevents the purge script from failing when docker is not available.
case "$*" in
  *image\ ls*|*image\ list*)
    # Return empty list - no images to remove
    exit 0
    ;;
  *system\ prune*)
    echo "Mock docker system prune: nothing to prune"
    exit 0
    ;;
  *rmi*)
    exit 0
    ;;
  *)
    exit 0
    ;;
esac

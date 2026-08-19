#!/bin/sh
# Mock curl: intercepts rmz binary downloads and serves a fake binary.
# For other URLs, passes through to the real curl.
# Honors both "curl URL | sh" (stdout) and "curl -o FILE URL" (file) forms.
out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
done

case "$*" in
  *rmz*)
    # Serve a fake rmz binary that just prints a version string
    payload='#!/bin/sh
echo "rmz 3.0.1"
exit 0'
    if [ -n "$out" ]; then
      printf '%s\n' "$payload" > "$out"
    else
      printf '%s\n' "$payload"
    fi
    exit 0
    ;;
  *)
    exec /usr/bin/curl "$@"
    ;;
esac

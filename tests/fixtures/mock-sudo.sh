#!/bin/sh
# Mock sudo: intercepts privileged commands that fail without CAP_SYS_ADMIN in Docker.
# For other commands, runs them directly (we are root in Docker containers).
case "$1" in
  losetup)
    case "$*" in
      *--find*) echo "/dev/loop0" ;;
      *) exit 0 ;;
    esac
    ;;
  fallocate)
    # Create an empty placeholder file at the target path (last argument)
    last=""
    for arg in "$@"; do last="$arg"; done
    mkdir -p "$(dirname "$last")" 2>/dev/null || true
    touch "$last" 2>/dev/null || true
    exit 0
    ;;
  mkfs.btrfs) exit 0 ;;
  btrfs) exit 0 ;;
  mount)
    # For /nix mounts, create the directory to simulate a successful mount
    case "$*" in
      *LABEL=nix*) mkdir -p /nix ;;
    esac
    exit 0
    ;;
  umount) exit 0 ;;
  rmz) exit 0 ;;
  apt-get)
    # Mock apt-get to avoid slow/failing package operations in Docker test env
    echo "Mock apt-get: $*"
    exit 0
    ;;
  dpkg)
    echo "Mock dpkg: $*"
    exit 0
    ;;
  ls)
    shift
    exec ls "$@"
    ;;
  du)
    shift
    exec du "$@" 2>/dev/null || true
    ;;
  df)
    shift
    exec df "$@"
    ;;
  tee)
    shift
    exec tee "$@"
    ;;
  *)
    # For all other commands, run them directly (we are root in Docker).
    # NOTE: do NOT shift here - $@ already contains the full command + args.
    exec "$@"
    ;;
esac

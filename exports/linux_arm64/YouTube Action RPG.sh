#!/bin/sh
printf '\033c\033]0;%s\a' YouTube Action RPG
base_path="$(dirname "$(realpath "$0")")"
"$base_path/YouTube Action RPG.arm64" "$@"

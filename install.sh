#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="${TARGET_DIR:-$HOME}"
DRY_RUN=false
BACKUP=false
PACKAGES=()
ACTIONS=()

usage() {
  cat <<EOF
Usage: $0 [options] <package> [package...]

Options:
  --dry-run    Show what would be copied, but make no changes
  --backup     Backup existing files before overwriting
  -h, --help   Show this help
EOF
}

# --- Parse arguments --------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --backup)
      BACKUP=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      PACKAGES+=("$1")
      shift
      ;;
  esac
done

if [ "${#PACKAGES[@]}" -eq 0 ]; then
  usage
  exit 1
fi

# --- Helpers ----------------------------------------------------------------

transform_path() {
  local path="$1"
  local dir
  local base

  dir="$(dirname "$path")"
  base="$(basename "$path")"

  if [[ "$base" == dot-* ]]; then
    base=".${base#dot-}"
  fi

  if [ "$dir" = "." ]; then
    echo "$base"
  else
    echo "$dir/$base"
  fi
}

# --- Build action plan ------------------------------------------------------

for package in "${PACKAGES[@]}"; do
  if [ ! -d "$package" ]; then
    echo "  Skipping '$package' (not a directory)"
    continue
  fi

  pushd "$package" > /dev/null

  while IFS= read -r -d '' file; do
    file="${file#./}"

    transformed="$(transform_path "$file")"
    src="$PWD/$file"
    dest="$TARGET_DIR/$transformed"

    ACTIONS+=("$src|$dest")
  done < <(find . -type f -print0)

  popd > /dev/null
done

if [ "${#ACTIONS[@]}" -eq 0 ]; then
  echo "Nothing to install."
  exit 0
fi

# --- Show plan --------------------------------------------------------------

echo "Planned actions:"
echo

for action in "${ACTIONS[@]}"; do
  IFS="|" read -r src dest <<< "$action"

  if [ -e "$dest" ]; then
    echo "  OVERWRITE $dest"
    if $BACKUP; then
      echo "    ↳ backup before overwrite"
    fi
  else
    echo "  CREATE    $dest"
  fi
done

echo

if $DRY_RUN; then
  echo "Dry run mode — no changes will be made."
  exit 0
fi

# --- Confirmation -----------------------------------------------------------

# read -r -p "Proceed with these changes? [y/N] " confirm
# if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
#   echo "Aborted."
#   exit 1
# fi

# --- Execute ----------------------------------------------------------------

BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

for action in "${ACTIONS[@]}"; do
  IFS="|" read -r src dest <<< "$action"

  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ] && $BACKUP; then
    cp -a "$dest" "$dest$BACKUP_SUFFIX"
  fi

  cp -f "$src" "$dest"
done

echo "Installation complete."

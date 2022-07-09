#!/usr/bin/env bash

set -e

df_dir="$(dirname "$(readlink -f "$0")")"
df_src_dir="${df_dir}/source"
df_bak_dir="${df_dir}/backup"
df_os="$(uname -s)"

echo "Running on '${df_os}'"
echo "Dotfiles in '${df_dir}'"
echo "Dotfiles source in '${df_src_dir}'"
echo "Backup directory in '${df_bak_dir}'"

# Backup existing regular files to backup folder before creating symlinks
cat << EOF
---
Backing up already existing regular files
EOF
cd "${df_src_dir}"
for f in $(find . -type f -xtype f -print | cut -c3-)
do
    if [ -f "${HOME}/$f" ] && [ ! -L "${HOME}/$f" ]
    then
	d=$(dirname "${df_bak_dir}/$f")
	[ ! -d "$d" ] && echo "Creating backup dir $d" && mkdir -p "$d"
        echo "Backing up \"${HOME}/$f\" to \"${df_bak_dir}/$f\""
	cp "${HOME}/$f" "${df_bak_dir}/$f"
    fi
done
cd - > /dev/null

# Create symlinks
cat << EOF
---
Creating symlinks
EOF
cd "${df_src_dir}"
for f in $(find . -type f -print | cut -c3-)
do
    d=$(dirname "${HOME}/$f")
    [ ! -d "$d" ] && echo "Creating dir $d" && mkdir -p "$d"
    echo "Creating link \"${HOME}/$f\" -> \"${df_src_dir}/$f\""
    ln -fs "${df_src_dir}/$f" "${HOME}/$f"
done
cd - > /dev/null

# Remove dead symlinks
cat << EOF
---
Finding dead symlinks (please remove following dead symlinks)
EOF
find "${HOME}" -maxdepth 1 -xtype l -print
[ -d "${HOME}/.config" ] && find "${HOME}/.config" -xtype l -print
# find "${HOME}" -xtype l -delete
# [ -d "${HOME}/.config" ] && find "${HOME}/.config" -xtype l -delete
# 

cat << EOF
---
All done
EOF

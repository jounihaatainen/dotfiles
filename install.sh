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

# Create needed directories
cat << EOF
---
Creating needed directories
EOF
cd "${df_src_dir}"
find . -type d -print | cut -c3- | xargs -I {} echo "mkdir -p \"${HOME}/{}\""
find . -type d -print | cut -c3- | xargs -I {} mkdir -p "${HOME}/{}"
cd - > /dev/null

# Backup existing regular files to backup folder before creating symlinks
#cat << EOF
#---
#Backing up already existing regular files
#EOF
#mkdir -p "${df_bak_dir}"
#cd "${df_src_dir}"
#find . -type f -print | cut -c3- | xargs -I {} [ -f "${HOME}/{}" ] && ! [ -L "${HOME}/{}" ] && echo "mv \"${HOME}/{}\" \"${df_bak_dir}/{}\""
#find . -type f -print | cut -c3- | xargs -I {} [ -f "${HOME}/{}" ] && ! [ -L "${HOME}/{}" ] && mv "${HOME}/{}" "${df_bak_dir}/{}"
#cd - > /dev/null

# Create symlinks
cat << EOF
---
Creating symlinks
EOF
cd "${df_src_dir}"
find . -type f -print | cut -c3- | xargs -I {} echo "ln -fs \"${df_src_dir}/{}\" \"${HOME}/{}\""
find . -type f -print | cut -c3- | xargs -I {} ln -fs "${df_src_dir}/{}" "${HOME}/{}"
cd - > /dev/null

# Remove dead symlinks
cat << EOF
---
Prune dead symlinks
EOF
find "${HOME}" -maxdepth 1 -xtype l -print
[ -d "${HOME}/.config" ] && find "${HOME}/.config" -xtype l -print
find "${HOME}" -xtype l -delete
[ -d "${HOME}/.config" ] && find "${HOME}/.config" -xtype l -delete

cat << EOF
---
All done
EOF

# Install packer for nvim
# XXX: nvim could do this by itself...
#git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

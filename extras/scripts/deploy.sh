#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy this Neovim configuration with a symlink
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
src=$(realpath "$script_dir/../..")
dest="$XDG_CONFIG_HOME/nvim"

# Delete pre-existing directory if we are trying to link it.
if [[ -d "$dest" ]]; then
    rm -r "$dest"
fi

ln -sfT "$src" "$dest"

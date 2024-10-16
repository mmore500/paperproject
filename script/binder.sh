#!/bin/bash

# Fetch all remote branches
git fetch --all --jobs $(nproc)

mkdir -p binder

# Loop through remote branches starting with 'binder'
for branch in $(git branch -r | grep 'origin/binder' | sed 's|origin/||'); do
    echo "Processing branch $branch"

    # Add the branch as a submodule
    git submodule add -b "$branch" "$(git config --get remote.origin.url)" "binder/$branch"
    git config -f .gitmodules submodule."binder/$branch".shallow true

done

# Initialize the submodule
git submodule update --init --recursive --depth 1 --jobs $(nproc)

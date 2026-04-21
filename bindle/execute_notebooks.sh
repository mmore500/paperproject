#!/bin/bash

################################################################################
echo
echo "running execute_notebooks.sh"
echo "---------------------------------------------"
################################################################################

# fail on error
set -e

################################################################################
echo
echo "other initialization"
echo "--------------------"
################################################################################

# adapted from https://stackoverflow.com/a/24114056
script_dir="$(dirname -- "$BASH_SOURCE")"
echo "script_dir ${script_dir}"

################################################################################
echo
echo "execute marimo notebooks in current directory"
echo "---------------------------------------------"
################################################################################

shopt -s nullglob

if [ $# -gt 0 ]; then
  cd "${script_dir}"
  notebooks=("$@")
else
  notebooks=("${script_dir}/"*.py)
fi

for notebook in "${notebooks[@]}"; do
  echo "notebook ${notebook}"
  export NOTEBOOK_NAME="$(basename "${notebook%.*}")"
  export NOTEBOOK_PATH="$(realpath "${notebook}")"
  notebook_dir="$(dirname -- "${notebook}")"
  output_ipynb="${notebook_dir}/${NOTEBOOK_NAME}.ipynb"
  # export marimo notebook to jupyter notebook with executed outputs
  # adapted from https://docs.marimo.io/guides/exporting/
  marimo export ipynb \
    --include-outputs \
    --sort topological \
    -f \
    "${notebook}" \
    -o "${output_ipynb}"
done

shopt -u nullglob

################################################################################
echo
echo "recurse to subdirectories"
echo "-------------------------"
################################################################################

shopt -s nullglob

for script in "${script_dir}/"*/execute_notebooks.sh; do
  "${script}" "$@"
done

shopt -u nullglob

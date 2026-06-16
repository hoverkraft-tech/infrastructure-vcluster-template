#!/bin/bash

set -eu -o pipefail

# asdf
if [ -r ".tool-versions" ]; then
  echo "+ adding asdf plugins"
  bash .devcontainer/scripts/asdf-plugins-add.sh

  echo "+ installing current tools versions with asdf"
  asdf install
else
  echo "- There is no '.tool-versions' in this workspace. skipping..."
fi
echo "+ asdf tools installed !"

# ssh
echo "+ configuring ssh"
bash .devcontainer/scripts/ssh-config.sh
echo "+ ssh configured"

# devx tools
echo "+ installing devx tools"
bash .devcontainer/scripts/devx-tools.sh
echo "+ devx tools installed !"

exit 0

#!/bin/bash

set -eu -o pipefail

for plugin in $(cat .tool-versions | grep -vE '^#' | awk '{ print $1 }'); do
  echo "--> asdf plugin: $plugin"
  asdf plugin add $plugin
done

asdf plugin update --all

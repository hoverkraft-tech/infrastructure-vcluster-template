#!/bin/bash

set -eu -o pipefail

mkdir -p "$HOME/.ssh/"
cp .devcontainer/files/ssh/* $HOME/.ssh/

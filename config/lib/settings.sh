#! /usr/bin/env bash

# Defines global settings.

# General
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# Homebrew
export HOMEBREW_CURL_RETRIES=3

# Repositories
export REPO_DOTFILES=1.0.0

# Applications
export DOCKER_APP_NAME="Docker.app"
export DOCKER_VOLUME_NAME="Docker"

if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
  export DOCKER_APP_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
else
  export DOCKER_APP_URL="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
fi

export POSTMAN_APP_NAME="Docker.app"
if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
  export POSTMAN_APP_URL="https://dl.pstmn.io/download/latest/osx_arm64"
else
  export POSTMAN_APP_URL="https://dl.pstmn.io/download/latest/osx_64"
fi

export GPG_KEYCHAIN_APP_NAME="GPG Keychain.app"
export GPG_KEYCHAIN_APP_URL="https://gpgtools.org/download"
export GPG_KEYCHAIN_VOLUME_NAME="GPG Suite"

# Application Extensions
export CURL_CURLRC_EXTENSION_PATH="$HOME/.curlrc"
export CURL_CURLRC_EXTENSION_URL="https://raw.githubusercontent.com/drduh/config/master/curlrc"
export PYENV_EXTENSION_ROOT="$HOME/.pyenv/plugins"
export PYENV_XXENV_EXTENSION_PATH="$PYENV_EXTENSION_ROOT/xxenv-latest"
export PYENV_XXENV_EXTENSION_URL="https://github.com/momo-lab/xxenv-latest"
export VIM_VIMRC_EXTENSION_PATH="$HOME/.vimrc"
export VIM_VIMRC_EXTENSION_SCRIPT="sh ./install_awesome_vimrc.sh"
export VIM_VIMRC_EXTENSION_URL="https://github.com/amix/vimrc"
export VIM_VIMRC_EXTENSION_VERSION="master"


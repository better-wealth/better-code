#! /usr/bin/env bash

################################################################################
# better-code/lib/settings.sh
# Defines custom settings.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


# config/bin/apply_basic_settings
export MAC_OS_LABEL="Macbook"
export MAC_OS_NAME="Macbook"
export DOCUMENTS="n"
export DOWNLOADS="n"

# Homebrew
export HOMEBREW_CURL_RETRIES=3

# Applications
export DOCKER_APP_NAME="Docker.app"
export DOCKER_VOLUME_NAME="Docker"

if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
  export DOCKER_APP_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
else
  export DOCKER_APP_URL="https://desktop.docker.com/mac/main/amd64/Docker.dmg"
fi

export POSTMAN_APP_NAME="Postman.app"
if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
  export POSTMAN_APP_URL="https://dl.pstmn.io/download/latest/osx_arm64"
else
  export POSTMAN_APP_URL="https://dl.pstmn.io/download/latest/osx_64"
fi

export ELM_APP_NAME="elm"
export ELM_APP_URL="https://github.com/elm/compiler/releases/download/0.19.1/installer-for-mac.pkg"

export KALEIDOSCOPE_APP_NAME="Kaleidoscope.app"
export KALEIDOSCOPE_APP_URL="https://kaleidoscope.app/download/latest/ks"

export SONOS_APP_NAME="Sonos S1 Controller.app"
export SONOS_VOLUME_NAME="Sonos"
export SONOS_APP_URL="https://www.sonos.com/redir/controller_software_mac"

export CLEANMYMAC_REPO_URL="https://github.com/thelamehacker/cleanmymac.git"
export CLEANMYMAC_REPO_VERSION="master"
export CLEANMYMAC_PROJECT_DIR="cleanmymac"
export CLEANMYMAC_SCRIPT="./install.sh"

# Application Extensions
export CURL_CURLRC_EXTENSION_PATH="$HOME/.curlrc"
export CURL_CURLRC_EXTENSION_URL="https://raw.githubusercontent.com/drduh/config/master/curlrc"
export PYENV_EXTENSION_ROOT="$HOME/.pyenv/plugins"
export PYENV_XXENV_EXTENSION_PATH="$PYENV_EXTENSION_ROOT/xxenv-latest"
export PYENV_XXENV_EXTENSION_URL="https://github.com/momo-lab/xxenv-latest"

# Dotfiles
export DOTFILES_VERSION="main"

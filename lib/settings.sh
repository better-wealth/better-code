#! /usr/bin/env bash

################################################################################
# better-code/lib/settings.sh
# Defines global settings.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'


export BETTER_CODE_WORK_PATH=/tmp/downloads
export BETTER_CODE_CONFIG_PATH="config"
export BETTER_CODE_XCODE_ACTIVE_DEVELOPER_DIRECTORY_PATH="$(xcode-select -p)"

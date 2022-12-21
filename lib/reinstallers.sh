#! /usr/bin/env bash

################################################################################
# better-code/lib/reinstallers.sh
# Defines reinstall functions.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


# Reinstall application.
reinstall_application() {
  uninstall_application
  bin/install_applications
}
export -f reinstall_application

# Reinstall extension.
reinstall_extension() {
  uninstall_extension
  bin/install_extensions
}
export -f reinstall_extension

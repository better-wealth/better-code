#! /usr/bin/env bash

################################################################################
# better-code/lib/uninstallers.sh
# Defines uninstall functions.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


# Uninstalls selected application.
uninstall_application() {
  # Only use environment keys that end with "APP_NAME".
  local keys=($(set | awk -F "=" '{print $1}' | grep ".*APP_NAME"))

  printf "Select application to uninstall:\n"
  for ((index = 0; index < ${#keys[*]}; index++)); do
    local app_file="${!keys[$index]}"
    printf "  $index: ${app_file}\n"
  done
  printf "  q: Quit/Exit\n\n"

  read -p "Enter selection: " response
  printf "\n"

  local regex="^[0-9]+$"
  if [[ $response =~ $regex ]]; then
    local app_file="${!keys[$response]}"
    local app_path=$(get_install_path "${app_file}")
    sudo rm -rf "$app_path"
    printf "Uninstalled: ${app_path}\n"
  fi
}
export -f uninstall_application

# Uninstalls cleanmymac.
uninstall_cleanmymac() {
  rm -rf $(which cleanmymac)
  rm -rf ~/.cleanmymac
  echo "Clean My macOS has been uninstalled. :("
}

# Uninstalls selected extension.
uninstall_extension() {
  # Only use environment keys that end with "EXTENSION_PATH".
  local keys=($(set | awk -F "=" '{print $1}' | grep ".*EXTENSION_PATH"))

  printf "Select extension to uninstall:\n"
  for ((index = 0; index < ${#keys[*]}; index++)); do
    local extension_path="${!keys[$index]}"
    printf "  $index: ${extension_path}\n"
  done
  printf "  q: Quit/Exit\n\n"

  read -p "Enter selection: " response
  printf "\n"

  local regex="^[0-9]+$"
  if [[ $response =~ $regex ]]; then
    local extension_path="${!keys[$response]}"
    rm -rf "${extension_path}"
    printf "Uninstalled: ${extension_path}\n"
  fi
}
export -f uninstall_extension

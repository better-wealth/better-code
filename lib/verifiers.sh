#! /usr/bin/env bash

################################################################################
# better-code/lib/verifiers.sh
# Defines verification/validation functions.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


# Checks for missing App Store applications.
verify_app_store_applications() {
  printf "\nChecking App Store applications...\n"

  local applications="$(mas list)"

  while read line; do
    if [[ "$line" == "mas install"* ]]; then
      local application=$(printf "$line" | awk '{print $3}')
      verify_listed_application "$application" "${applications[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_app_store"

  printf "App Store check complete.\n"
}
export -f verify_app_store_applications

# Verifies application exists.
# Parameters: $1 (required) - The file name.
verify_application() {
  local file_name="$1"
  local install_path=$(get_install_path "$file_name")

  if [[ ! -e "$install_path" ]]; then
    printf " - Missing: $file_name\n"
  fi
}
export -f verify_application

# Checks for missing applications suffixed by "APP_NAME" as defined in settings.sh.
verify_applications() {
  printf "\nChecking application software...\n"

  # Only use environment keys that end with "APP_NAME".
  local file_names=$(set | awk -F "=" '{print $1}' | grep ".*APP_NAME")

  # For each application name, check to see if the application is installed. Otherwise, skip.
  for name in $file_names; do
    verify_application "${!name}"
  done

  printf "Application software check complete.\n"
}
export -f verify_applications

# Checks for missing extensions suffixed by "EXTENSION_PATH" as defined in settings.sh.
verify_extensions() {
  printf "\nChecking application extensions...\n"

  # Only use environment keys that end with "EXTENSION_PATH".
  local extensions=$(set | awk -F "=" '{print $1}' | grep ".*EXTENSION_PATH")

  # For each extension, check to see if the extension is installed. Otherwise, skip.
  for extension in $extensions; do
    # Evaluate/extract the key (extension) value and pass it on for verfication.
    verify_path "${!extension}"
  done

  printf "Application extension check complete.\n"
}
export -f verify_extensions

# Checks for missing Homebrew casks.
verify_homebrew_casks() {
  printf "\nChecking Homebrew casks...\n"

  local applications="$(brew list --casks)"

  while read line; do
    if [[ "$line" == "brew cask install"* ]]; then
      local application=$(printf "$line" | awk '{print $4}')
      verify_listed_application "$application" "${applications[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_homebrew_casks"

  printf "Homebrew cask check complete.\n"
}
export -f verify_homebrew_casks

# Checks for missing Homebrew formulas.
verify_homebrew_formulas() {
  printf "Checking Homebrew formulas...\n"

  local applications="$(brew list --formulae)"

  while read line; do
    if [[ "$line" == "brew install"* ]]; then
      local application=$(printf "$line" | awk '{print $3}')

      # Exception: "gpg" is the binary but is listed as "gnugp".
      if [[ "$application" == "gpg" ]]; then
        application="gnupg"
      fi

      verify_listed_application "$application" "${applications[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_homebrew_formulas"

  printf "Homebrew formula check complete.\n"
}
export -f verify_homebrew_formulas

# Verifies listed application exists.
# Parameters: $1 (required) - The current application, $2 (required) - The application list.
verify_listed_application() {
  local application="$1"
  local applications="$2"

  if [[ "${applications[*]}" != *"$application"* ]]; then
    printf " - Missing: $application\n"
  fi
}
export -f verify_listed_application

# Verifies path exists.
# Parameters: $1 (required) - The path.
verify_path() {
  local path="$1"

  if [[ ! -e "$path" ]]; then
    printf " - Missing: $path\n"
  fi
}
export -f verify_path

# Checks for missing Node packages.
verify_node_packages() {
  printf "\nChecking Node packages...\n"

  while read line; do
    if [[ "$line" == "npm "* ]]; then
      local package=$(printf "$line" | awk '{print $4}')
      local packages=($(npm list --global --depth=0 | grep "$package"))

      verify_listed_application "$package" "${packages[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_node_packages"

  printf "Node packages check complete.\n"
}
export -f verify_node_packages

# Checks for missing Ruby gems.
verify_ruby_gems() {
  local gems="$(gem list --no-versions)"

  printf "\nChecking Ruby gems...\n"

  while read line; do
    if [[ "$line" == "gem install"* ]]; then
      local gem=$(printf "$line" | awk '{print $3}')
      verify_listed_application "$gem" "${gems[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_ruby_gems"

  printf "Ruby gems check complete.\n"
}
export -f verify_ruby_gems

# Checks for missing Rust crates.
verify_rust_crates() {
  printf "\nChecking Rust crates...\n"

  local crates="$(ls -A1 $HOME/.cargo/bin)"

  while read line; do
    if [[ "$line" == "cargo install"* ]]; then
      local crate=$(printf "$line" | awk '{print $3}')
      verify_listed_application "$crate" "${crates[*]}"
    fi
  done < "$BETTER_CODE_CONFIG_PATH/bin/install_rust_crates"

  printf "Rust crates check complete.\n"
}
export -f verify_rust_crates

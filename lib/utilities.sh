#! /usr/bin/env bash

################################################################################
# better-code/lib/utilities.sh
# Defines general utility functions.
# https://github.com/better-wealth/better-code
# MIT License
# 2022 (C) John Patrick Roach
################################################################################


# Caffeinate machine.
caffeinate_machine() {
  local pid=$(pgrep -x caffeinate)

  if [[ -n "$pid" ]]; then
    printf "Machine is already caffeinated!\n"
  else
    caffeinate -s -u -d -i -t 3153600000 > /dev/null &
    printf "Machine caffeinated.\n"
  fi
}
export -f caffeinate_machine

# Cleans work path for temporary processing of installs.
clean_work_path() {
  rm -rf "$BETTER_CODE_WORK_PATH"
}
export -f clean_work_path

# Answers the file or directory basename.
# Parameters: $1 (required) - The file path.
get_basename() {
  printf "${1##*/}" # Answers file or directory name.
}
export -f get_basename

# Answers the file extension.
# Parameters: $1 (required) - The file name.
get_extension() {
  local name=$(get_basename "$1")
  local extension="${1##*.}" # Excludes dot.

  if [[ "$name" == "$extension" ]]; then
    printf ''
  else
    printf "$extension"
  fi
}
export -f get_extension

# Answers Homebrew root path.
# Parameters: None.
get_homebrew_root() {
  if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
    printf "%s" "/opt/homebrew"
  else
    printf "%s" "/usr/local/Homebrew"
  fi
}
export -f get_homebrew_root

# Answers Homebrew binary root path.
# Parameters: None.
get_homebrew_bin_root() {
  if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
    printf "%s" "/opt/homebrew/bin"
  else
    printf "%s" "/usr/local/bin"
  fi
}
export -f get_homebrew_bin_root

# Answers the full install path (including file name) for file name.
# Parameters: $1 (required) - The file name.
get_install_path() {
  local file_name="$1"
  local install_path=$(get_install_root "$file_name")
  printf "$install_path/$file_name"
}
export -f get_install_path

# Answers the root install path for file name.
# Parameters: $1 (required) - The file name.
get_install_root() {
  local file_name="$1"
  local file_extension=$(get_extension "$file_name")

  # Special cases not supported by Homebrew.
  if [[ "$file_name" == "elm" ]]; then
    printf "/usr/local/bin"
    return
  fi

  # Dynamically build the install path based on file extension.
  case $file_extension in
    '')
      printf "$(get_homebrew_bin_root)";;
    'app')
      printf "/Applications";;
    'prefPane')
      printf "/Library/PreferencePanes";;
    'qlgenerator')
      printf "/Library/QuickLook";;
    *)
      printf "/tmp/unknown";;
  esac
}
export -f get_install_root

# Checks Mac App Store (mas) CLI has been installed and exits if otherwise.
# Parameters: None.
check_mas_install() {
  if ! command -v mas > /dev/null; then
    printf "%s\n" "ERROR: Mac App Store (mas) CLI can't be found."
    printf "%s\n" "       Please ensure Homebrew and mas (i.e. brew install mas) have been installed."
    exit 1
  fi
}
export -f check_mas_install

# Configures shell for new machines and ensures PATH is properly configured for running scripts.
# Parameters: None.
configure_environment() {
  if [[ ! -s "$HOME/.zprofile" ]]; then
    printf "%s\n" "if [ -f ~/.zshrc ]; then . ~/.zshrc; fi" > "$HOME/.zprofile"
  fi

  if [[ ! -s "$HOME/.zshrc" ]]; then
    printf "%s\n" 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"' > "$HOME/.zshrc"
    source "$HOME/.zshrc"
  fi
}
export -f configure_environment

# Shows managed files.
show_files() {
  printf "%s\n" "Managed Dotfiles:"

  for file in $(home_files); do
    printf "  %s\n" "$(base_dest_file $file)"
  done
}
export -f show_files

# Installs all files.
install_files() {
  printf "%s\n" "Installing dotfiles..."

  for file in $(home_files); do
    install_file $file
  done

  printf "%s\n" "Dotfiles install complete!"
}
export -f install_files

# Installs a file.
# Parameters:
# $1 = The file name.
install_file() {
  local source_file="$1"
  local dest_file="$HOME/$(base_dest_file $source_file)"
  local dest_dir="$(dirname $dest_file)"

  if [[ "$(basename $source_file)" == "mkdir.command" ]]; then
    mkdir -p $dest_dir
    return
  fi

  if [[ ! -f "$dest_file" ]]; then
    mkdir -p "$dest_dir"
    cp "$source_file" "$dest_file"
    printf "  + %s\n" "$dest_file"
  fi
}
export -f install_file

# Links all files.
link_files() {
  printf "%s\n" "Linking dotfiles..."

  for file in $(home_files); do
    link_file $file
  done

  printf "%s\n" "Dotfiles link complete!"
}
export -f link_files

# Links a dotfile to this project.
# Parameters:
# $1 = The file name.
link_file() {
  local source_file="$PWD/$1"
  local dest_file="$HOME/$(base_dest_file $1)"
  local dest_dir="$(dirname $dest_file)"
  local excludes=".+(env.sh.tt|git/configuration.tt)$"

  if [[ "$(basename $source_file)" == "mkdir.command" ]]; then
    mkdir -p $dest_dir
    return
  fi

  if [[ ! -h "$dest_file" && ! "$source_file" =~ $excludes ]]; then
    read -r -p "  Link $dest_file -> $source_file (y/n)? " response
    if [[ $response == 'y' ]]; then
      mkdir -p "$dest_dir"
      ln -sf "$source_file" "$dest_file"
    fi
  fi
}
export -f link_file

# Checks all files for changes.
check_files() {
  printf "%s\n" "Dotfiles Changes:"

  for file in $(home_files); do
    check_file $file
  done

  printf "%s\n" "Dotfiles check complete!"
}
export -f check_files

# Checks a file for changes.
# Parameters:
# $1 = The file name.
check_file() {
  local source_file="$1"
  local dest_file="$HOME/$(base_dest_file $1)"
  local excludes=".+command$"

  if [[ "$source_file" =~ $excludes ]]; then
    return
  elif [[ -e "$dest_file" || -h "$dest_file" ]]; then
    if [[ "$(diff $dest_file $source_file)" != '' ]]; then
      printf "  * %s\n" "$dest_file"
    fi
  else
    printf "  - %s\n" "$dest_file"
  fi
}
export -f check_file

# Delete files.
delete_files() {
  printf "%s\n" "Deleting dotfiles..."

  for file in $(home_files); do
    delete_file $file
  done

  printf "%s\n" "Dotfiles deletion complete!"
}
export -f delete_files

# Delete file.
# Parameters:
# $1 = The file name.
delete_file() {
  local dest_file="$HOME/$(base_dest_file $1)"
  local excludes=".+(env.sh|.gitconfig)$"

  # Proceed only if file exists.
  if [[ -e "$dest_file" || -h "$dest_file" ]] && [[ ! "$dest_file" =~ $excludes ]]; then
    read -r -p "  Delete $dest_file (y/n)? " response
    if [[ $response == 'y' ]]; then
      rm -f "$dest_file"
    fi
  fi
}
export -f delete_file

# Answers a list of files stored in the home_files folder of this project.
home_files() {
  for file in $(find home_files -type f); do
    printf "%s\n" "$file"
  done
}
export -f home_files

base_dest_file() {
  local source_file="$1"
  local computed_file=''

  printf "${source_file%.*}" | sed 's/home_files\///g'
}
export -f base_dest_file

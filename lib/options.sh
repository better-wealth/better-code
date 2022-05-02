#! /usr/bin/env bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters: $1 (required) - The option to process.
process_option() {
  case $1 in
    'B')
      bin/create_boot_disk;;
    'b')
      bin/apply_basic_settings;;
    't')
      bin/install_dev_tools;;
    'ht')
      bin/homebrew_tap;;
    'hf')
      bin/install_homebrew_formulas;;
    'hc')
      bin/install_homebrew_casks;;
    'm')
      bin/install_app_store;;
    'a')
      bin/install_applications;;
    'x')
      bin/install_extensions;;
    'df')
      bin/install_dotfiles;;
    'np')
      bin/install_node_packages;;
    'rg')
      bin/install_ruby_gems;;
    'rc')
      bin/install_rust_crates;;
    'd')
      bin/apply_default_settings;;
    'cs')
      bin/configure_software;;
    'i')
      caffeinate_machine
      bin/apply_basic_settings
      bin/install_dev_tools
      bin/homebrew_tap
      bin/install_homebrew_formulas
      bin/install_homebrew_casks
      bin/install_app_store
      bin/install_applications
      bin/install_extensions
      bin/install_dotfiles
      bin/install_node_packages
      bin/install_ruby_gems
      bin/install_rust_crates
      bin/apply_default_settings
      bin/configure_software
      clean_work_path;;
    'R')
      caffeinate_machine
      bin/restore_backup;;
    'c')
      verify_homebrew_formulas
      verify_homebrew_casks
      verify_app_store_applications
      verify_applications
      verify_extensions
      verify_node_packages
      verify_ruby_gems
      verify_rust_crates;;
    'C')
      caffeinate_machine;;
    'ua')
      uninstall_application;;
    'ux')
      uninstall_extension;;
    'ra')
      reinstall_application;;
    'rx')
      reinstall_extension;;
    'w')
      clean_work_path;;
    'sf')
      show_files;;
    'if')
      install_files;;
    'lf')
      link_files;;
    'cf')
      check_files;;
    'df')
      delete_files;;
    'q');;
    *)
      printf "ERROR: Invalid option.\n";;
  esac
}
export -f process_option
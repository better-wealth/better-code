<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [better-code](#better-code)
  - [Summary](#summary)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Pre-Install](#pre-install)
    - [Install](#install)
  - [Customization](#customization)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# better-code
 A better coding environment manager.

## Summary

This project aims provide a framework for auditing, configuring, and verifying best practices for code environments on the latest macOS software. It utilizes a combination of tools from various resources to make regular, automated, up-to-date configuraiton possible.

## Table of Contents

* [Features](https://github.com/better-wealth/better-code#features)
* [Usage](https://github.com/better-wealth/better-code#usage)
  * [Customization](https://github.com/better-wealth/better-code#customization)

## Features

* Provides a command line interface, written in Bash, with no additional dependencies for
  installation and management of a coding environment on a macOS machine.
* Supports installing [Xcode Command Line Tools](https://developer.apple.com/xcode).
* Supports installing related [Homebrew](http://brew.sh) formulas and casks.
* Supports installing related [App Store](http://www.apple.com/macosx/whats-new/app-store.html) software.
* Supports installing related non-App Store software applications.
* Supports installing related software application extensions.
* Supports installing related dotfile configurations.
* Supports restoration of machine backups.

## Usage

The following will walk you through the steps of installing/re-installing your machine.

### Pre-Install

Ensure you have the following in place for your macOS machine:

* Ensure a recent backup of your machine exists and works properly.

### Install

* To install, run:

```shell
git clone https://github.com/better-wealth/better-code.git
cd better-code
```

* Run the following:

```shell
bin/better_code
```

* You will be presented with the following options (listed in order of use):

```
Install:
   b:  Apply basic settings.
   t:  Install development tools.
  hf:  Install Homebrew Formulas.
  hc:  Install Homebrew Casks.
   m:  Install Mac App Store software.
   a:  Install application software.
   x:  Install application software extensions.
  df:  Install dotfiles.
  np:  Install Node packages.
  rg:  Install Ruby gems.
  rc:  Install Rust crates.
   d:  Apply default settings.
  cs:  Configure installed software.
   i:  Install everything (i.e. executes all install options in order listed).
Restore:
   R:  Restore settings from backup.
Manage:
   c:  Check status of managed software.
   C:  Caffeinate machine.
  ua:  Uninstall application software.
  ux:  Uninstall application software extension.
  ra:  Reinstall application software.
  rx:  Reinstall application software extension.
   w:  Clean work (temp) directory.
   q:  Quit/Exit.
```

Choose option `i` to run a full install or select a specific option to run a single action. Each
option is designed to be re-run if necessary. This can also be handy for performing upgrades,
re-running a missing/failed install, etc.

The option prompt can be skipped by passing the desired option directly to the `bin/better_code` script. For
example, executing `bin/better_code i` will execute the full install process.

The machine should be rebooted after all install tasks have completed to ensure all settings have
been loaded.

It is recommended that the `better-code` project directory not be deleted and kept on the local machine in order to manage installed software and benefit from future upgrades.

## Customization

While this project’s configuration is opinionated and tailored for my setup, you can easily fork
this project and customize it for your environment. Start by editing the files found in the `config/bin`
and `config/lib` directories.

*TIP* : The installer determines which applications/extensions to install as defined in the `config/settings.sh` script. Applications defined with the “APP_NAME” suffix and extensions defined with the “EXTENSION_PATH” suffix inform the installer what to care about. Removing/commenting out these applications/extensions within the `config/settings.sh` file will cause the installer to skip these applications/extensions.

All executable scripts can be found in the `config/bin` folder:

* `config/bin/apply_basic_settings` (optional, customizable): Applies basic and initial settings for
  setting up a machine.
* `config/bin/apply_default_settings` (optional, customizable): Applies bare minimum system and application
  defaults.
* `config/bin/configure_software` (optional, customizable): Configures installed software as part of the
  post install process.
* `config/bin/create_boot_disk` (optional): Creates a macOS boot disk.
* `config/bin/install_app_store` (optional, customizable): Installs macOS, GUI-based, App Store
  applications.
* `config/bin/install_applications` (optional, customizable): Installs macOS, GUI-based, non-App Store
  applications.
* `config/bin/install_dev_tools` (required): Installs macOS development tools required by Homebrew.
* `config/bin/install_dotfiles` (optional, customizable): Installs personal dotfiles so the system is
  tailored to your workflow.
* `config/bin/install_extensions` (optional, customizable): Installs macOS application extensions and
  add-ons.
* `config/bin/install_homebrew_casks` (optional, customizable): Installs Homebrew Formulas.
* `config/bin/install_homebrew_formulas` (optional, customizable): Installs Homebrew Casks.
* `config/bin/install_node_packages` (optional, customizable): Installs Node packages.
* `config/bin/install_ruby_gems` (optional, customizable): Installs Ruby gems.
* `config/bin/install_rust_crates` (optional, customizable): Installs Rust crates.
* `config/bin/restore_backup` (optional, customizable): Restores system/application settings from backup
  image.

The `lib` folder provides the base framework for installing, re-installing, and uninstalling
software. Everything provided via the [`config/lib` ](https://www.alchemists.io/projects/mac_os-config)folder is built upon the functions found in the `lib` folder.

* `config/lib/settings.sh`: Defines global settings for software applications, extensions, etc.

#!/usr/bin/env bash

set -e

sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2;
sudo pmset -a destroyfvkeyonstandby 1;
sudo pmset -a hibernatemode 25;
sudo pmset -a powernap 0;
sudo pmset -a standby 0;
sudo pmset -a standbydelay 0;
sudo pmset -a autopoweroff 0;
defaults write com.apple.screensaver askForPassword -int 1;
defaults write com.apple.screensaver askForPasswordDelay -int 0;
defaults write com.apple.finder AppleShowAllFiles -bool true;
chflags nohidden ~/Library;
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;
defaults write com.apple.CrashReporter DialogType none;
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts;

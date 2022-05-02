#!/bin/sh

displayHelp() {
    clear
    echo "NAME"
    echo "    cleanmymac -- a set of simple command line cleaners for developers using macOS"
    echo ""
    echo "DESCRIPTION"
    echo "    Clean My macOS is built for modern macOS systems. It performs maintainance for mostly commonly used"
    echo "    components in the core OS and third party tools with a single terminal command."
    echo ""
    echo "    The following parameters are supported:"
    echo ""
    echo "    cleanmymac"
    echo "        Runs all cleaners"
    echo ""
    echo "    cleanmymac update"
    echo "        Performs self-update"
    echo ""
    echo "    cleanmymac help"
    echo "        Displays this help"
    echo ""
    echo "PROJECT LINK"
    echo "    https://github.com/thelamehacker/cleanmymac"
    echo ""
    echo ""
}

runUpdate() {
    echo "Running system self-update"
    echo "=========================="
    
    pushd "$(cat ~/.cleanmymac/path)" > /dev/null
    git pull
    popd > /dev/null
    echo ""
}

invalidWarning() {
    echo "You have passed an invalid argument. Please run 'cleanmymac help' to list supported commands."
    echo ""
}

# Check if brew is installed and perform maintainance
if hash brew 2>/dev/null; then

  echo "Performing Homebrew maintainance"
  echo "================================"
  echo ""
  echo "Checking for updates for homebrew..."
  brew update
  brew upgrade
  brew upgrade --cask
  brew outdated --cask | cut -f 1 | xargs brew reinstall --cask
  echo ""

  echo "Calling the brewery doctor for the mandatory health checkup..."
  brew doctor
  brew missing
  echo ""

  echo "Cleaning the brewery..."
  brew cleanup -s
  echo ""

fi


# Check if Anaconda is installed and upgrade packages
if hash conda 2>/dev/null; then

  echo "Updating Anaconda packages"
  echo "=========================="
  conda update --all
  echo ""

fi

# Check if npm is installed and perform updates
if hash npm 2>/dev/null; then

    echo "Performing npm maintainance"
    echo "==========================="
    echo ""

    echo "Updating npm core..."
    npm install npm@latest -g
    echo ""

    echo "Finding outdated npm packages..."
    npm outdated -g --depth=0
    echo ""

    echo "Updating npm packages..."
    npm --depth 9999 update -g --no-save
    echo ""

fi

# Check if yarn is installed and perform updates
if hash yarn 2>/dev/null; then

  echo "Performing yarn maintainance"
  echo "============================"
  echo ""

  echo "Updating yarn core..."
  yarn global upgrade -s
  echo ""

  echo "Cleaning yarn cache..."
  yarn cache clean
  echo ""

fi

if hash composer 2>/dev/null; then

  echo "Performing composer maintainance"
  echo "================================"
  echo ""

  echo "Updating composer core..."
  composer global update
  echo ""

  echo "Cleaning composer cache..."
  composer clearcache
  echo ""

fi

coreOSCleaner () {

echo "Rebuilding XPC cache..."
sudo /usr/libexec/xpchelper --rebuild-cache >/dev/null 2>/dev/null

echo "Rebuilding CoreDuet..."
sudo rm -fr /var/db/coreduet/* >/dev/null 2>/dev/null

echo "Rebuilding launch services..."
sudo /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -seed -domain local -domain system -domain user >/dev/null 2>/dev/null

echo "Flushing DNS cache and restarting mDNS..."
sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder >/dev/null 2>/dev/null

echo "Clearing BootCache..."
sudo rm -f /private/var/db/BootCache.playlist >/dev/null 2>/dev/null

echo "Updating dyld cache..."
sudo update_dyld_shared_cache -root / -force >/dev/null 2>/dev/null

echo "Rebuilding Kernel extension cache..."
#sudo touch /System/Library/Extensions && sudo kextcache -u / >/dev/null 2>/dev/null
sudo kextcache -u / >/dev/null 2>/dev/null # Minor tidbit solution with Big Sur

echo "Running daily, weekly and monthly maintenance scripts..."
sudo periodic daily weekly monthly >/dev/null 2>/dev/null

echo ""

}

echo "macOS core cleaner"
echo "=================="
echo "Note: You will need to provide administrative access for macOS maintenance scripts to run."
echo ""

if [ $(id -u) != 0 ]; then
   sudo "$0"
   exit
fi

coreOSCleaner


#Delete Saved SSIDs For Security
#Be Sure To Set Home And Work SSID for ease of use.
printf "Deleting saved wireless networks.\n"
homessid="AddMe"
workssid="AddMe"
IFS=$'\n'
for ssid in $(networksetup -listpreferredwirelessnetworks en0 | grep -v "Preferred networks on en0:" | grep -v $homessid | grep -v $workssid | sed "s/[\	]//g")
do
    networksetup -removepreferredwirelessnetwork en0 "$ssid"  > /dev/null 2>&1
done

#Taking out the trash.
printf "Emptying the trash.\n"
sudo rm -rfv /Volumes/*/.Trashes > /dev/null 2>&1
sudo rm -rfv ~/.Trash  > /dev/null 2>&1

#Clean the logs.
printf "Emptying the system log files.\n"
sudo rm -rfv /private/var/log/*  > /dev/null 2>&1
sudo rm -rfv /Library/Logs/DiagnosticReports/* > /dev/null 2>&1

printf "Deleting the quicklook files.\n"
sudo rm -rf /private/var/folders/ > /dev/null 2>&1

#Cleaning Up Homebrew.
printf "Cleaning up Homebrew.\n"
brew cleanup --force -s > /dev/null 2>&1
brew cask cleanup > /dev/null 2>&1
rm -rfv /Library/Caches/Homebrew/* > /dev/null 2>&1
brew tap --repair > /dev/null 2>&1
brew update > /dev/null 2>&1
brew upgrade > /dev/null 2>&1

#Cleaning Up Ruby.
printf "Cleanup up Ruby.\n"
gem cleanup > /dev/null 2>&1

#Purging Memory.
printf "Purging memory.\n"
sudo purge > /dev/null 2>&1

#Removing Known SSH Hosts
printf "Removing known ssh hosts.\n"
sudo rm -f /Users/"$(whoami)"/.ssh/known_hosts > /dev/null 2>&1

#Securly Erasing Data.
printf "Securely erasing free space (This will take a while). \n"
diskutil secureErase freespace 0 "$( df -h / | tail -n 1 | awk '{print $1}')" > /dev/null 2>&1

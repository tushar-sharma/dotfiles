# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#
# Run ./set-defaults.sh and you'll be good to go.

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
# Flwv, Nlsv, clmv, icnv => Flow, List, Column, Icon...
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Spotlight is a bitch
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Notification Center
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist

# WHY IN THE HELL IS THIS A THING! I NEVER WANT THINGS TO BE SLOW...
defaults write com.apple.finder FXEnableSlowAnimation -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

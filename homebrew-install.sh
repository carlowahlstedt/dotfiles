
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# copy from where ever my script is
brew install kubectx
brew install k9s
brew install eksctl
brew install kubectl
brew install helm
brew install watch
brew install octant
brew install git
brew install git-credential-manager
brew install azure-cli
brew install go
brew install node
brew install openssl
brew install angular-cli
brew install watchman
brew install ansible
brew install ffmpeg
brew install packer
brew install sqlite
brew install youtube-dl
brew install terminal-notifier
brew install sops
brew install docker

brew tap domt4/autoupdate
brew autoupdate --start 43200 --upgrade --cleanup --enable-notification

brew tap azure/functions
brew install azure-functions-core-tools

#apps
brew cask install visual-studio-code
brew cask install dropbox
brew cask install google-chrome
brew cask install firefox
brew cask install kap
brew cask install powershell
brew cask install microsoft-azure-storage-explorer
brew cask install 1password
brew cask install alfred
brew cask install rectangle
brew cask install docker
brew cask install handbrake
brew cask install vlc
brew cask install sketch
brew cask install jump
brew cask install slack
brew cask install the-unarchiver
brew cask install virtualbox
brew cask install charles
brew cask install postman
brew cask install logos
brew cask install microsoft-office
brew cask install microsoft-teams
brew cask install brave-browser
brew cask install istat-menus
brew cask install keybase
brew cask install iterm2
brew cask install adobe-acrobat-reader
brew cask install azure-data-studio
brew cask install macdown
brew cask install vagrant
brew cask install wireshark
brew cask install dozer
brew cask install rocket
brew cask install krisp
brew cask install BetterTouchTool
brew cask install zoomus

#fonts
brew tap homebrew/cask-fonts
brew cask install font-awesome-terminal-fonts
brew cask install font-fira-code
brew cask install font-fira-mono-for-powerline
brew cask install font-fira-mono
brew cask install font-fira-sans
brew cask install font-firacode-nerd-font-mono
brew cask install font-firacode-nerd-font
brew cask install font-roboto-condensed
brew cask install font-roboto-mono-for-powerline
brew cask install font-roboto-mono
brew cask install font-roboto-slab
brew cask install font-roboto
brew cask install font-robotomono-nerd-font-mono
brew cask install font-robotomono-nerd-font

# Install pip
sudo easy_install pip
# Update pip
sudo pip install --upgrade pip

# start apps
open /Applications/Rectangle.app
open /Applications/Dozer.app
open /Applications/BetterTouchTool.app
open "/Applications/Brave Browser.app"
open /Applications/docker.app
open "/Applications/1Password 7.app"

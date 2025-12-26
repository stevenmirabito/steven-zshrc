#!/bin/zsh
# Installer for steven-zshrc
# Author: Steven Mirabito (steven@stevenmirabito.com)
# Author: Marc Billow (marc@billow.me)
set -e

# Paths
ZSH_LOC=`which zsh`
ETC_SHELL=`grep "$ZSH_LOC" /etc/shells`

if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
fi

if [ ! -n "$ZSH_CUSTOM" ]; then
    ZSH_CUSTOM="${ZSH}/custom"
fi

export RUNZSH=no
export NVM_LAZY_LOAD=true
ZSH_HIGHLIGHT_PLUGIN="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
ZSH_SUGGEST_PLUGIN="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
ZSH_NVM_PLUGIN="${ZSH_CUSTOM}/plugins/zsh-nvm"
ZSH_NEAT_THEME="${ZSH_CUSTOM}/repos/neat"

# Styles
RESET="\e[0m"
BOLD="\e[1m"
PRIMARY="${BOLD}\e[94m"

# Helper Functions
install_plugin () {
    # Expects 3 arguments: $1=<name>, $2=<path>, $3=<clone-url>
    if [[ -d "$2" ]]; then
        echo "${PRIMARY}📦  Updating $1...${RESET}"
        cd $2
        git fetch --all
        git reset --hard origin/master
    else
        echo "${PRIMARY}📦  Installing $1...${RESET}"
        git clone -q $3 $2
    fi
}

install_theme() {
    # Extends install_plugin, expects same arguments
    install_plugin "$1 theme" $2 $3
    cd $2
    for i in *.zsh(.N); do
        rm -f "${ZSH_CUSTOM}/${i}-theme"
        ln -s "`pwd`/${i}" "${ZSH_CUSTOM}/${i}-theme"
    done
    for i in *.zsh-theme(.N); do
        rm -f "${ZSH_CUSTOM}/${i}"
        ln -s "`pwd`/${i}" "${ZSH_CUSTOM}/${i}"
    done
}

echo -e "${PRIMARY}"
echo "         __                                       __             "
echo "   _____/ /____ _   _____  ____       ____  _____/ /_  __________"
echo "  / ___/ __/ _ \ | / / _ \/ __ \_____/_  / / ___/ __ \/ ___/ ___/"
echo " (__  ) /_/  __/ |/ /  __/ / / /_____// /_(__  ) / / / /  / /__  "
printf "/____/\__/\___/|___/\___/_/ /_/      /___/____/_/ /_/_/   \___/\n\n${RESET}"

if [[ "$ETC_SHELL" == "" ]]; then
	sudo printf "\n$ZSH_LOC" >> /etc/shells
	echo -e "${PRIMARY}✅  ZSH has been added to /etc/shells.${RESET}"
fi

if [[ "$SHELL" != "$ZSH_LOC" ]]; then
	chsh -s "$ZSH_LOC" $USER
	echo -e "${PRIMARY}✅  User \"$USER\"'s shell has been altered.${RESET}"
fi

if [[ -d "$ZSH" ]]; then
    echo -e "${PRIMARY}🛠  Upgrading Oh My Zsh...${RESET}"
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/upgrade.sh)"
else
    echo -e "${PRIMARY}📥  Installing Oh My Zsh...${RESET}"
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo -e "${PRIMARY}📦  Pulling ZSH config and setting ZSH environment...${RESET}"
echo "# Path to your oh-my-zsh installation.\nexport ZSH=$HOME/.oh-my-zsh\n" > ~/.zshrc
curl -fL --progress-bar "https://raw.githubusercontent.com/stevenmirabito/steven-zshrc/main/configs/zshrc" > ~/.zshrc

echo -e "${PRIMARY}🎨  Grabbing ZSH theme and plugins...${RESET}"
install_plugin "zsh-syntax-highlighting" ${ZSH_HIGHLIGHT_PLUGIN} "https://github.com/zsh-users/zsh-syntax-highlighting.git"
install_plugin "zsh-autosuggestions" ${ZSH_SUGGEST_PLUGIN} "https://github.com/zsh-users/zsh-autosuggestions.git"
install_plugin "zsh-nvm" ${ZSH_NVM_PLUGIN} "https://github.com/lukechilds/zsh-nvm.git"
install_theme "Neat" ${ZSH_NEAT_THEME} "https://github.com/stevenmirabito/neat.git"

if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ ! -f "/opt/homebrew/bin/brew" ]]; then
        echo -e "${PRIMARY}🛠  Installing Brew...${RESET}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/steven/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if [[ ! -f "$(brew --prefix)/bin/eza" ]]; then
        echo -e "${PRIMARY}📦  Installing packages...${RESET}"
        brew install eza
    fi

    if [[ ! -f "$(brew --prefix)/bin/pinentry-mac" ]]; then
        echo -e "${PRIMARY}🎒  Setting up GnuPG...${RESET}"
        brew install gpg2 gnupg pinentry-mac
        mkdir -p ~/.gnupg
        curl -fL --progress-bar "https://raw.githubusercontent.com/stevenmirabito/steven-zshrc/main/configs/gpg-agent.conf" > ~/.gnupg/gpg-agent.conf
        chmod -R 600 ~/.gnupg
        chmod 700 ~/.gnupg
    fi

    if [[ ! -d "$(brew --prefix)/opt/asdf" ]]; then
        echo -e "${PRIMARY}🎒  Setting up asdf...${RESET}"
        brew install asdf readline xz
        source $(brew --prefix)/opt/asdf/libexec/asdf.sh
        echo -e "${PRIMARY}🛠  Installing Node.js...${RESET}"
        $(brew --prefix)/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
        $(brew --prefix)/bin/asdf install nodejs latest
        $(brew --prefix)/bin/asdf set -u nodejs latest
        echo -e "${PRIMARY}🛠  Installing Python...${RESET}"
        $(brew --prefix)/bin/asdf plugin add python https://github.com/asdf-community/asdf-python.git
        $(brew --prefix)/bin/asdf install python latest
        $(brew --prefix)/bin/asdf set -u python latest
        pip install --upgrade pip pipenv
    fi
fi

source ~/.zshrc
printf "${PRIMARY}🏁  Done!${RESET}\n"

#!/bin/zsh
# Installer for steven-zshrc
# Author: Steven Mirabito (steven@stevenmirabito.com)
# Author: Marc Billow (marc@billow.me)

# Paths
ZSH_LOC=`which zsh`
ETC_SHELL=`grep "$ZSH_LOC" /etc/shells`

if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
fi

if [ ! -n "$ZSH_CUSTOM" ]; then
    ZSH_CUSTOM="${ZSH}/custom"
fi

ZSH_HIGHLIGHT_PLUGIN="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
ZSH_SUGGEST_PLUGIN="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
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

if [[ "$SHELL" != "$ZSH_LOC" ]]
then
	chsh -s "$ZSH_LOC" $USER
	echo -e "${PRIMARY}✅  User \"$USER\"'s shell has been altered.${RESET}"
fi

if [ -d "$ZSH" ]; then
    echo -e "${PRIMARY}🛠  Upgrading Oh My Zsh...${RESET}"
    sh -c "`curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/upgrade.sh`"
else
    echo -e "${PRIMARY}📥  Installing Oh My Zsh...${RESET}"
    sh -c "`curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh`"
fi

echo -e "${PRIMARY}📦  Pulling ZSH config and setting ZSH environment...${RESET}"
echo "# Path to your oh-my-zsh installation.\nexport ZSH=$HOME/.oh-my-zsh\n" > ~/.zshrc
curl -fL --progress-bar "https://setup.stevenmirabito.com/configs/zshrc" >> ~/.zshrc

echo -e "${PRIMARY}🎨  Grabbing ZSH theme and plugins....${RESET}"

install_plugin "zsh-syntax-highlighting" ${ZSH_HIGHLIGHT_PLUGIN} "https://github.com/zsh-users/zsh-syntax-highlighting.git"
install_plugin "zsh-autosuggestions" ${ZSH_SUGGEST_PLUGIN} "https://github.com/zsh-users/zsh-autosuggestions.git"
install_theme "Neat" ${ZSH_NEAT_THEME} "https://github.com/stevenmirabito/neat.git"

source ~/.zshrc
printf "${PRIMARY}🏁  Done!${RESET}\n"

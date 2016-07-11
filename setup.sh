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

# Styles
RESET="\e[0m"
BOLD="\e[1m"
LOGO="${BOLD}\e[92m"
PRIMARY="${BOLD}\e[91m"

echo -e "${LOGO}"
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
curl -fL --progress-bar "https://setup.stevenmirabito.com/theme/steven.zsh-theme" > ~/.oh-my-zsh/themes/steven.zsh-theme

if [[ -d "${ZSH_HIGHLIGHT_PLUGIN}" ]]; then
    echo -e "${PRIMARY}🖌  Updating zsh-syntax-highlighting...${RESET}"
    cd ${ZSH_HIGHLIGHT_PLUGIN}
    git fetch --all
    git reset --hard origin/master
else
    echo -e "${PRIMARY}🖌  Installing zsh-syntax-highlighting...${RESET}"
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_HIGHLIGHT_PLUGIN}
fi

if [[ -d "${ZSH_SUGGEST_PLUGIN}" ]]; then
    echo "${PRIMARY}🔎  Updating zsh-autosuggestions...${RESET}"
    cd ${ZSH_SUGGEST_PLUGIN}
    git fetch --all
    git reset --hard origin/master
else
    echo "${PRIMARY}🔎  Installing zsh-autosuggestions...${RESET}"
    git clone -q https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_SUGGEST_PLUGIN}
fi

source ~/.zshrc
printf "${PRIMARY}🏁  Done!${RESET}\n"

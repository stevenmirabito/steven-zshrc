ZSH_LOC=$(which zsh)
ETC_SHELL=$(grep "$ZSH_LOC" /etc/shells)

printf "              __    _ ____             
   ____ ___  / /_  (_) / /___ _      __
  / __ \`__ \\\/ __ \\/ / / / __ \\ | /| / /
 / / / / / / /_/ / / / / /_/ / |/ |/ / 
/_/ /_/ /_/_.___/_/_/_/\\____/|__/|__/  
                                       
Welcome to your new home! Follow the prompts.\n"


if [[ "$ETC_SHELL" == "" ]]
then
	sudo printf "\n$ZSH_LOC" >> /etc/shells
	printf "ZSH has been added to /etc/shells."
fi

if [[ "$SHELL" != "$ZSH_LOC" ]]
then
	chsh -s "$ZSH_LOC" $USER
	printf "User \"$USER\"'s shell has been altered."
fi

printf "Installing OMZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "Pulling ZSH config and setting ZSH environment."
printf "# Path to your oh-my-zsh installation.\nexport ZSH=$HOME/.oh-my-zsh\n" > ~/.zshrc
curl --progress-bar "https://raw.githubusercontent.com/mbillow/right-at-home/master/configs/zshrc" >> ~/.zshrc

printf "Grabbing ZSH theme and plugins."
curl --progress-bar "https://raw.githubusercontent.com/mbillow/right-at-home/master/theme/mbillow.zsh-theme" > ~/.oh-my-zsh/themes/mbillow.zsh-theme
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone -q https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

source ~/.zshrc
printf "\nYou should be all set!\n"

ZSH_LOC=$(which zsh)
ETC_SHELL=$(grep "$ZSH_LOC" /etc/shells)

echo "              __    _ ____             
   ____ ___  / /_  (_) / /___ _      __
  / __ \`__ \\\/ __ \\/ / / / __ \\ | /| / /
 / / / / / / /_/ / / / / /_/ / |/ |/ / 
/_/ /_/ /_/_.___/_/_/_/\\____/|__/|__/  
                                       
Welcome to your new home! Follow the prompts.\n"


if [[ "$ETC_SHELL" == "" ]]
then
	sudo echo "\n$ZSH_LOC" >> /etc/shells
	echo "ZSH has been added to /etc/shells."
fi

if [[ "$SHELL" != "$ZSH_LOC" ]]
then
	chsh -s "$ZSH_LOC" $USER
	echo "User \"$USER\"'s shell has been altered."
fi

echo "Installing OMZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Pulling ZSH config and setting ZSH environment."
echo "# Path to your oh-my-zsh installation.\nexport ZSH=$HOME/.oh-my-zsh\n" > ~/.zshrc
curl --progress-bar "https://raw.githubusercontent.com/mbillow/right-at-home/master/configs/zshrc" >> ~/.zshrc

echo "Grabbing ZSH theme and plugins."
curl --progress-bar "https://raw.githubusercontent.com/mbillow/right-at-home/master/theme/mbillow.zsh-theme" >> ~/.oh-my-zsh/themes/mbillow.zsh-theme
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone -q https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "\nYou should be all set, just restart your terminal emulator.\n"
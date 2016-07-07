ZSH_LOC=$(which zsh)

echo "              __    _ ____             
   ____ ___  / /_  (_) / /___ _      __
  / __ \`__ \\\/ __ \\/ / / / __ \\ | /| / /
 / / / / / / /_/ / / / / /_/ / |/ |/ / 
/_/ /_/ /_/_.___/_/_/_/\\____/|__/|__/  
                                       
Welcome to your new home! Follow the prompts.\n"


read -p "Does ZSH need to be added to /etc/shells?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	ADD_ETCSHELL=true
else
	ADD_ETCSHELL=false
fi

read -p "We have detected an installed of ZSH in "$ZSH_LOC", is this correct?" -n 1 -r
echo "\n"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	SET_ZSH=true
else
	SET_ZSH=false
fi

echo $ADD_ETCSHELL
echo $SET_ZSH


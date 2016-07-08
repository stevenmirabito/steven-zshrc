#Right at Home
######A simple personal setup script to simplify the customization of new hosts.

###To Run:
`sh -c "$(curl -fsSL http://home.billow.me)"`

###What this script does:
1. Find the local ZSH installation.
2. Checks if ZSH is in /etc/shells.
3. Sets the user's shell to the detected ZSH installation.
4. Installs Oh-My-ZSH.
5. Pulls the RC File, theme, and any extensions.

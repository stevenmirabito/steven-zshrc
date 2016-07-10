steven-zshrc
=============
###### A simple setup script to install my person ZSH config

Installation
-------------
If you trust me, here's a one-line installation:

    curl -o- -fsSL https://setup.stevenmirabito.com | zsh

What this script does:
-----------------------
1. Find the local ZSH installation.
2. Checks if ZSH is in /etc/shells.
3. Sets the user's shell to the detected ZSH installation.
4. Installs Oh-My-ZSH.
5. Pulls the RC File and any extensions.

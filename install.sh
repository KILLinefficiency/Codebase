#!/bin/bash

cat << INSTALL

This installer will install Codebase on your system.

The following changes will be made:

1) New directory ~/.CODEBASE will be created.
2) ~/.CODEBASE will be added to the PATH Variable.

Make sure that you have the Bash Shell installed.

INSTALL

read -p "Proceed with the installation? [Y/n] " confirm

if [ -z $confirm ] || [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
  if [ -d ~/.CODEBASE ]; then
    rm -rf ~/.CODEBASE
    echo "Previously installed Codebase is now removed."
    mkdir ~/.CODEBASE
  else
    mkdir ~/.CODEBASE
  fi
  cp cbase.sh ~/.CODEBASE/cbase
  chmod 755 ~/.CODEBASE/cbase
  echo "Codebase installed."
  echo 'export PATH="~/.CODEBASE:$PATH"' >> ~/.bashrc
  echo "Added to PATH Variable."
  source ~/.bashrc
  echo -e "\nDone!\nInstalled at ~/.CODEBASE\n"
else
  echo "Installation process aborted!"
  exit
fi

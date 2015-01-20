#!/bin/sh

# exit if a shell command fails
set -e

# install destination
file="/usr/local/bin/whitespace"

# prompt user if `whitespace` is already in `/usr/local/bin`
if [ -f $file ]; then
  while true; do
    read -p "Override /usr/local/bin/whitespace (y/n)? " yn
    case $yn in
      [Yy]*)
        break;;
      *)
        echo "Installation cancelled"
        exit;;
    esac
  done
fi

# download the script
curl -sS -o $file https://raw.githubusercontent.com/yuanqing/whitespace/master/whitespace

# make the script executable
chmod +x $file

# print a success message
echo "Installed whitespace into /usr/local/bin"

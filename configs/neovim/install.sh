#!/bin/sh

# ===============================================================================
# install.sh
# ===============================================================================
# Author			: Sebastian Johansson
# Year			: 2024-10-14
# License		: GPLv3
# Description	: A simple install and setup script for NeoVim.
# ===============================================================================

#====================================================
#	Variables Section
#====================================================

PLATFORM="LINUX"
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
INSTALL_PATH="${HOME}/.config/nvim"

#====================================================

printf "Running script from directory [ %s ]\n" "${SCRIPT_PATH}"

# WSL can have issues so we need to detect it
# early.
if command -v clip.exe > /dev/null; then
	printf "Windows[WSL] platform detected!\n"
fi

# If there is no NeoVim installed on the system,
# then there is no point in continuing.
if command -v nvim > /dev/null; then
	printf "Neovim is installed, preceding\n"
else
	printf "Neovim not installed aborting\n"
	exit 1
fi

# Checking the core requirements for vim and the script.
while read -r i; do
	if command -v "${i}" > /dev/null; then
		printf "[ OK ] \t%s : Is installed.\n" "${i}"
	else
		printf "[ ERROR ] \t%s : Is not installed.\n" "${i}"
		exit 1
	fi
done < requirements.txt

# Making sure that the user knows what is about to happen.
while true; do
	printf "This install will write to [ %s ] ALL DATA WILL BE LOST, do you want to continue [ YES / NO ]: " "${INSTALL_PATH}"
	read -r CHOICE

	if [ "NO" = "${CHOICE}" ]; then
		printf "Aborting install of config files.\n"
		exit 0
	elif [ "YES" = "${CHOICE}" ]; then
		printf "Understood preceding in installing configs.\n"
		break
	fi

	if command -v clear > /dev/null; then
		clear
	fi
done 

# Removing the old configuration.
rm -rf "${INSTALL_PATH}"
rm -rf "${HOME}/.local/share/nvim/*"

# Creating the directory before coping the files.
mkdir -pv "${INSTALL_PATH}/lua"

# Installing the files
cp -r "${SCRIPT_PATH}/lua" "${INSTALL_PATH}"

# Setting up the init.lua file so that NeoVim can use the
# plugin files supplied.
printf "require(\"main\")\n" > "${INSTALL_PATH}/init.lua"

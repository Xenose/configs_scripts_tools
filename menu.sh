#!/bin/sh

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
SELECTED=$(whiptail --separate-output --checklist "Select install items" 60 120 50 \
	"install_neovim_config" "Install NeoVim config" off \
	2>&1 >/dev/tty)

echo "${SELECTED}"

for i in ${SELECTED}; do
	case "$i" in
		"install_neovim_config")
			sh -c "${SCRIPT_PATH}/configs/neovim/install.sh"
			;;
	esac
done

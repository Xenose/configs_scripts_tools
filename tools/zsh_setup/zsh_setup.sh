#!/bin/bash

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
SHELL_D="${HOME}/.config/shell.d"

mkdir -pv "${SHELL_D}"

SELECTED=$(whiptail --separate-output --checklist "Select shell functions to copy" 60 120 50 \
	"copy.sh" "Copy.sh a cross shell function for coping." on \
	"copy.sh" "Notify.sh a cross shell function for notifying the user." on \
	2>&1 >/dev/tty)

for i in ${SELECTED}; do
	case "$i" in
		"copy.sh")
			cp "${SCRIPT_PATH}/scripts/copy/" "${SHELL_D}"
			;;
	esac
done

case "${SHELL}" in
	"zsh")
		cat "${SCRIPT_PATH}/tools/zsh_setup.sh" >> "${HOME}/,zshrc"
		;;
esac

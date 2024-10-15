
for i in $(find "${SHELL_D}" -iname "*.sh" -type f 2>/dev/null); do
	echo -e "${i}"
	source "${i}"
done

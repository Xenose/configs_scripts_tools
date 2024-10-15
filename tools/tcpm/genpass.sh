#!/bin/bash

genpass() {
   local ALPHA="ABCDEFGHIKLMNOPQRSTVXYZabcdefghiklmnopqrstvxyz"
   local NUMBERS="1234567890"
   local SYMBOLS="!@#$%^&*()_+-={[]};:'\"\\/\`~<>,.?"

   local PASSWORD=""

   local USE_SYMBOLS=true
   local LENGTH=$(( ((RANDOM<<15)|RANDOM) % 64 + 16 ))

   eval set -- $(getopt -o "l:" --long "no-symbols,length:" -- "$@")

   while true; do
      case "$1" in
         --no-symbols)
            local USE_SYMBOLS=false
            ;;

         -l|--length)
            local LENGTH="$2"
            shift
            ;;

         --)
            shift
            break
            ;;

         *)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
      esac
      shift
   done

   if command -v pwgen > /dev/null; then
      local OPT=""

      if [ true = "${USE_SYMBOLS}" ]; then
         OPT="-s"
      fi

      PASSWORD=$(pwgen -1 ${OPT} ${LENGTH})
   else
      local TABLE="${ALPHA}${NUMBERS}"

      if [ true = "${USE_SYMBOLS}" ]; then
         local TABLE="${ALPHA}${NUMBERS}${SYMBOLS}"
      fi

      PASSWORD=$(echo $(tr -dc ${TABLE} < /dev/urandom | head -c "${LENGTH}"))
   fi

   echo "${PASSWORD}"
}

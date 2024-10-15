#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

#include dependencies
source "${SCRIPT_PATH}/../notify/notify.sh"


source "${SCRIPT_PATH}/menu.sh"
source "${SCRIPT_PATH}/genpass.sh"

if [ -z "${VAULT_PATH}" ]; then
   VAULT_PATH="${HOME}/.password-store/"
fi

declare -A MENU_OPTIONS=(
   ["Create credential"]="MENU_CREDENTIAL_CREATE"
   ["Update credential"]="MENU_CREDENTIAL_UPDATE"
   ["Insert One Time Password"]="MENU_CREDENTIAL_INSERT_ONE_TIME_PASSWORD"
)

MENU_SELECTED="MENU_PASSWORD_PROVIDER"

SELECT_MENU="menu -i -W 0.3 --center -R 10 -l 40 --fixed-height 45"
INPUT_MENU="menu -ci -W 0.31"

eval set -- $(getopt -o "om" --long "otp,menu" -- "$@")

while true; do
   case "$1" in
      -m|--menu)
         MENU_SELECTED="$(printf "%s\n" "${!MENU_OPTIONS[@]}" | eval "${SELECT_MENU}")"
         MENU_SELECTED=${MENU_OPTIONS["$MENU_SELECTED"]}
         ;;
      -o|--otp)
         MENU_SELECTED="MENU_OTP_PROVIDER"
         ;;
      --)
         shift
         break
         ;;
   esac
   shift
done

# Executing the menu options
case "${MENU_SELECTED}" in
   "MENU_CREDENTIAL_CREATE")
      FILE_CONTENT=""

      FILENAME=$(:|  eval "${INPUT_MENU} -p Filename:")

      if [ -z ${FILENAME} ]; then
         notify-user "No filename provided"
         exit 1
      elif [ -f "${VAULT_PATH}/${FILENAME}.gpg" ]; then
         FORCE_CREATION=$(echo -e "NO\nYES"| eval "${INPUT_MENU} -l 2 -p 'File exists force creation?'")

         if [ "NO" = ${FORCE_CREATION} ]; then
            notify-user "Password already exists aborting"
            exit 1
         fi
      fi

      # Asking for additional optional information
      USERNAME=$(:|  eval "${INPUT_MENU} -p Username:")
      EMAIL=$(:|     eval "${INPUT_MENU} -p Email:")
      COMPANY=$(:|   eval "${INPUT_MENU} -p Company:")

      MESSAGE="Do you wish to continue? [ FILENAME : "${FILENAME}" ]"

      if [ -n ${USERNAME} ]; then
         MESSAGE="${MESSAGE} [ USERNAME : "${USERNAME}" ]"
         FILE_CONTENT="${FILE_CONTENT}\nusername: ${USERNAME}"
      fi

      if [ -n "${EMAIL}" ]; then
         MESSAGE="${MESSAGE} [ EMAIL : "${EMAIL}" ]"
         FILE_CONTENT="${FILE_CONTENT}\nemail: ${EMAIL}"
      fi

      if [ -n "${COMPANY}" ]; then
         MESSAGE="${MESSAGE} [ COMPANY : "${COMPANY}" ]"
         FILE_CONTENT="${FILE_CONTENT}\ncompany: ${COMPANY}"
      fi

      CHOICE=$(echo -e "YES\nNO" | eval "${INPUT_MENU} -l 2 -p '${MESSAGE}'")

      if [ "YES" = ${CHOICE} ]; then
         
         PASSWORD_LENGTH=$(:| eval "${INPUT_MENU} -p length:")
         PASSWORD_SYMBOLS=$(echo -e "YES\nNO"| eval "${INPUT_MENU} -l 2 -p 'Use symbols:'")

         PASSWORD_COMMAND="genpass --length ${PASSWORD_LENGTH}"
        
         if [ "NO" = ${PASSWORD_SYMBOLS} ]; then
            PASSWORD_COMMAND="${PASSWORD_COMMAND} --no-symbols"
         fi

         FILE_CONTENT="$(eval "${PASSWORD_COMMAND}")${FILE_CONTENT}"
         echo -e "${FILE_CONTENT}" | gpg --encrypt --recipient "$(cat ${VAULT_PATH}/.gpg-id)" > "${VAULT_PATH}/${FILENAME}.gpg"

         echo -e "\n${FILE_CONTENT}"
         notify-user "password copied to clipboard"
      fi
      ;; # End of MENU_CREDENTIAL_CREATE

   "MENU_PASSWORD_PROVIDER")
      PASSWORD=$(
         find "${VAULT_PATH}" -name '*.gpg' |
         sed "s|${VAULT_PATH}||" |
         sed "s|.gpg||" | eval "${SELECT_MENU}"
      )
      
      pass -c "$PASSWORD"
      ;;

   "MENU_OTP_PROVIDER")
      PASSWORD=$(
         find "${VAULT_PATH}" -name '*.gpg' |
         sed "s|${VAULT_PATH}||" |
         sed "s|.gpg||" | eval "${SELECT_MENU}"
      )

      pass otp -c "$PASSWORD"
      ;;
esac

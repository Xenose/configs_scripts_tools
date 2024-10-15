#!/bin/bash

menu() {
   __EC=""
   PIPED=""
   
   OPT_CENTER=false
   OPT_IGNORE_CASE=false
   OPT_LINES=""
   OPT_WIDTH=""
   OPT_PRINT=""

   while IFS= read -r line; do
      PIPED+="${line}\n"
   done

   PIPED=$(echo -e "${PIPED}" | sed '/^$/d')

   eval set -- $(getopt -o "cif:l:p:R:W:" --long "center,ignore-case,fixed-height:,lines:,print:,radius:,width:" -- "$@")

   while true; do
      case "$1" in
         -c|--center)
            OPT_CENTER=true
            ;;

         -f|--fixed-height)
            OPT_FIXED_HEIGHT="$2"
            shift
            ;;

         -l|--lines)
            OPT_LINES="$2"
            shift
            ;;

         -i|--ignore-case)
            OPT_IGNORE_CASE=true
            ;;

         -R|--radius)
            OPT_RADIUS="$2"
            shift
            ;;

         -W|--width)
            OPT_WIDTH="$2"
            shift
            ;;

         -p|--print)
            OPT_PRINT="$2"
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

   if [ -z "${__EC}" ]; then
      if command -v bemenu > /dev/null; then
 
         [ -n "${OPT_WIDTH}" ] && __EC="${__EC} -W ${OPT_WIDTH}"
         [ -n "${OPT_LINES}" ] && __EC="${__EC} -l ${OPT_LINES}"
         [ -n "${OPT_PRINT}" ] && __EC="${__EC} -p '${OPT_PRINT}'"
         [ -n "${OPT_RADIUS}" ] && __EC="${__EC} -R ${OPT_RADIUS}"
         [ -n "${OPT_FIXED_HEIGHT}" ] && __EC="${__EC} --fixed-height ${OPT_FIXED_HEIGHT}"

         [ true = ${OPT_CENTER} ] && __EC="${__EC} -c"
         [ true = ${OPT_IGNORE_CASE} ] &&__EC="${__EC} -i"

         __EC="bemenu ${__EC}"

      elif command -v dmenu > /dev/null; then
         
         [ -n "${OPT_WIDTH}" ] && __EC="${__EC} -W ${OPT_WIDTH}"
         [ -n "${OPT_LINES}" ] && __EC="${__EC} -l ${OPT_LINES}"
         [ -n "${OPT_PRINT}" ] && __EC="${__EC} -p '${OPT_PRINT}'"
         [ -n "${OPT_RADIUS}" ] && __EC="${__EC} -R ${OPT_RADIUS}"
         [ -n "${OPT_FIXED_HEIGHT}" ] && __EC="${__EC} --fixed-height ${OPT_FIXED_HEIGHT}"

         [ true = ${OPT_CENTER} ] && __EC="${__EC} -c"
         [ true = ${OPT_IGNORE_CASE} ] &&__EC="${__EC} -i"

         __EC="dmenu  ${__EC}"

      elif command -v rofi > /dev/null; then
      
         [ -n "${OPT_LINES}" ] &&  __EC="${__EC} -fixed-num-lines ${OPT_LINES}"

         __EC="rofi ${__EC}"

      else
         echo "No menu system installed [ bemenu, dmenu or other ]"
         exit 1
      fi
   fi

   CMD="printf '%s' \"${PIPED}\" | ${__EC}"
   echo $(eval "${CMD}")
}

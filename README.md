# configs_scripts_tools

## intel_backlight.sh
This scripts allows me to control backlighting for the CHUWI(Intel N5100),
it reads the max value from the max_brightness file and divides it in the
number of steps we want to take between the value 0 to 100(in this case
it takes 100 steps).

For editing the /sys/class/backlight/intel_backlight files we need to add
the user to the 'video' group.

For more information see the [Arch Linux wiki](https://wiki.archlinux.org/title/Backlight).

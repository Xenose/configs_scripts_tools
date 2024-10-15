# The-Complex-Pass-Menu-TCPM
The Complex Pass Menu or TCMP for short is written as a alternative for [PassMenu](https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu)
as I wanted more functionality.

## Supported features currently
* Copying passwords
* Copying OTP
* Creating new passwords

## Planed features
* Insert OTP
* Exporting to KeepassXC using KeepassXC-cli

## Command line options
* No command will launch the password menu interface.
* otp  : Will launch the one time password menu.
* menu : Will launch the options menu.

## Hyprland configuration example
~/.config/hypr/hyprland.conf

```
bind = $mainMod, O, exec, ~/.scripts/The-Complex-Pass-Menu-TCPM/source/tcpm.sh
bind = $mainMod, I, exec, ~/.scripts/The-Complex-Pass-Menu-TCPM/source/tcpm.sh --otp
bind = $mainMod, U, exec, ~/.scripts/The-Complex-Pass-Menu-TCPM/source/tcpm.sh --menu
```

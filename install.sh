#!/bin/bash

themes=(
    "Touhou 6 Menu [4:3] (800x600 | 1024x768 | 1280x960)"
    "Touhou 6 Menu [4:3 HD] (1440x1080 | 1600x1200)"
    "Touhou 6 Menu [16:9] (1024x576 | 1280x720)"
    "Touhou 6 Menu [16:9 HD] (1600x900 | 1920x1080)"
    "Touhou 6 Menu [16:9 HD-2] (2560x1440)"
)

themes_dirs=(
    "./themes/th06-menu/4:3"
    "./themes/th06-menu/4:3_HD"
    "./themes/th06-menu/16:9"
    "./themes/th06-menu/16:9_HD"
    "./themes/th06-menu/16:9_HD-2"
)

themes_names=(
    "th06-menu-4x3"
    "th06-menu-4x3-HD"
    "th06-menu-16x9"
    "th06-menu-16x9-HD"
    "th06-menu-16x9-HD-2"
)

echo " _____         _                ___          _      _____ _"
echo "|_   _|__ _  _| |_  ___ _  _   / __|_ _ _  _| |__  |_   _| |_  ___ _ __  ___ ___"
echo "  | |/ _ \ || | ' \/ _ \ || | | (_ | '_| || | '_ \   | | | ' \/ -_) '  \/ -_|_-<"
echo "  |_|\___/\_,_|_||_\___/\_,_|  \___|_|  \_,_|_.__/   |_| |_||_\___|_|_|_\___/__/"
echo "                                                                   by KNZodiac24"
for i in ${!themes[@]}; do
    echo $(expr $i + 1). ${themes[$i]}
done
echo
read -p "Choose the theme to be installed: " op
echo

if ! [[ $op =~ ^[1-5]$ ]]; then
    echo "Invalid option. Please re-run the script."
    exit 1
fi

cd ${themes_dirs[$(expr $op - 1)]}

theme_source_dir=$(pwd)
theme_name=${themes_names[$(expr $op - 1)]}

echo Preparing theme assets...

cd /boot/grub/themes/
rm -rf $theme_name
mkdir $theme_name
cd $theme_name
cp $theme_source_dir/* .

echo Verifying GRUB_THEME variable...

theme_var=$(grep GRUB_THEME /etc/default/grub)

if [[ $theme_var ]]; then
    sed -i '/GRUB_THEME/c\GRUB_THEME='$(pwd)'/theme.txt' /etc/default/grub
    echo GRUB_THEME variable updated at /etc/default/grub
else
    echo GRUB_THEME variable not found. Adding it to /etc/default/grub
    echo >> /etc/default/grub
    echo GRUB_THEME=$(pwd) >> /etc/default/grub
fi

echo Theme installed successfully in $(pwd)

echo "Updating grub config (/boot/grub/grub.cfg)..."
grub-mkconfig -o /boot/grub/grub.cfg
